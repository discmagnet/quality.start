quality <- function(season, tag){
  # INPUTS:   season -> which year? (e.g. 2016)
  #           tag    -> the suffix after the player's name
  #                     to identify the season (e.g. "'16")
  # OUTPUTS:  # of starts, # of quality starts, the
  #           quality start rate, and the average normalized
  #           runs allowed for every pitcher to start in
  #           the given MLB season
  # FUNCTION: With the given year, it computes the run
  #           expectancy matrix, manipulates the raw
  #           season data, computes whether each start
  #           is classified as "quality", and further
  #           manipulates the data to tell us quality
  #           start information for every pitcher that
  #           season.
  # ~ TIME:   5 min 30 sec
  
  # Make sure the plyr, dplyr, and tidyr packages are
  # loaded.
  library(plyr)
  library(dplyr)
  library(tidyr)
  
  # Obtain full season data and run expectancy matrix
  #------------------------------------------------------------
  
  data.file <- paste("all", season, ".csv", sep="")
  data <- read.csv(data.file, header=FALSE)
  fields <- read.csv("fields.csv")
  names(data) <- fields[, "Header"]
  
  data$RUNS <- with(data, AWAY_SCORE_CT + HOME_SCORE_CT)
  data$HALF.INNING <- with(data, 
                           paste(GAME_ID, INN_CT, BAT_HOME_ID))
  
  data$RUNS.SCORED <- with(data, (BAT_DEST_ID > 3) +
                             (RUN1_DEST_ID > 3) + (RUN2_DEST_ID > 3) + (RUN3_DEST_ID > 3))
  RUNS.SCORED.INNING <- aggregate(data$RUNS.SCORED, 
                                  list(HALF.INNING = data$HALF.INNING), sum)
  
  RUNS.SCORED.START <- aggregate(data$RUNS, 
                                 list(HALF.INNING = data$HALF.INNING), "[", 1)
  
  MAX <- data.frame(HALF.INNING=RUNS.SCORED.START$HALF.INNING)
  MAX$x <- RUNS.SCORED.INNING$x + RUNS.SCORED.START$x
  data <- merge(data, MAX)
  N <- ncol(data)
  names(data)[N] <- "MAX.RUNS"
  
  data$RUNS.ROI <- data$MAX.RUNS - data$RUNS
  
  get.state <- function(runner1, runner2, runner3, outs){
    runners <- paste(runner1, runner2, runner3, sep="")
    paste(runners, outs)                      
  }
  
  RUNNER1 <- ifelse(as.character(data[,"BASE1_RUN_ID"])=="", 0, 1)
  RUNNER2 <- ifelse(as.character(data[,"BASE2_RUN_ID"])=="", 0, 1)
  RUNNER3 <- ifelse(as.character(data[,"BASE3_RUN_ID"])=="", 0, 1)
  data$STATE <- get.state(RUNNER1, RUNNER2, RUNNER3, data$OUTS_CT)
  
  NRUNNER1 <- with(data, as.numeric(RUN1_DEST_ID==1 | BAT_DEST_ID==1))
  NRUNNER2 <- with(data, as.numeric(RUN1_DEST_ID==2 | RUN2_DEST_ID==2 | BAT_DEST_ID==2))
  NRUNNER3 <- with(data, as.numeric(RUN1_DEST_ID==3 | RUN2_DEST_ID==3 |
                                      RUN3_DEST_ID==3 | BAT_DEST_ID==3))
  NOUTS <- with(data, OUTS_CT + EVENT_OUTS_CT)
  
  data$NEW.STATE <- get.state(NRUNNER1, NRUNNER2, NRUNNER3, NOUTS)
  
  data <- subset(data, (STATE!=NEW.STATE) | (RUNS.SCORED>0))
  
  data.outs <- ddply(data, .(HALF.INNING), summarize,
                     Outs.Inning = sum(EVENT_OUTS_CT))
  data <- merge(data, data.outs)
  
  dataC <- subset(data, Outs.Inning == 3)
  
  RUNS <- with(dataC,aggregate(RUNS.ROI,list(STATE),mean))
  RUNS$Outs <- substr(RUNS$Group,5,5)
  RUNS <- RUNS[order(RUNS$Outs),]
  rem <- matrix(round(RUNS$x,3),8,3)
  
  #------------------------------------------------------------
  # Consolidate and manipulate data to achieve final line score of every start
  pitch <- select(data, HALF.INNING, GAME_ID, INN_CT, BAT_HOME_ID, OUTS_CT, AWAY_SCORE_CT, HOME_SCORE_CT, RESP_PIT_ID, NEW.STATE, RUNS.SCORED)
  pitch <- unite(pitch, GAME.ID.TEAM, GAME_ID, BAT_HOME_ID, sep=" ", remove=FALSE)
  pitch <- arrange(group_by(pitch,GAME.ID.TEAM),INN_CT)
  pitch <- mutate(group_by(pitch,GAME.ID.TEAM),SP.ID = RESP_PIT_ID[1])
  pitch <- filter(pitch, RESP_PIT_ID == SP.ID)
  pitch <- summarise_each(group_by(pitch,GAME.ID.TEAM),funs(last))
  
  # Create variable RA (runs allowed)
  pitch$RA <- pitch$BAT_HOME_ID*(pitch$HOME_SCORE_CT)+(1-pitch$BAT_HOME_ID)*(pitch$AWAY_SCORE_CT)+pitch$RUNS.SCORED
  
  # Sort data, put pitchers in alphabetical order
  pitch <- arrange(pitch,SP.ID)
  
  # Consolidate data
  pitch <- select(pitch, GAME.ID.TEAM,INN_CT,NEW.STATE,SP.ID,RA)
  
  # Compute expected runs added for not completing an inning
  pitch <- mutate(pitch, ERC = (NEW.STATE=="000 0")*rem[1,1] + (NEW.STATE=="000 1")*rem[1,2] + (NEW.STATE=="000 2")*rem[1,3] + (NEW.STATE=="001 0")*rem[2,1] + (NEW.STATE=="001 1")*rem[2,2] + (NEW.STATE=="001 2")*rem[2,3] + (NEW.STATE=="010 0")*rem[3,1] + (NEW.STATE=="010 1")*rem[3,2] + (NEW.STATE=="010 2")*rem[3,3] + (NEW.STATE=="011 0")*rem[4,1] + (NEW.STATE=="011 1")*rem[4,2] + (NEW.STATE=="011 2")*rem[4,3] + (NEW.STATE=="100 0")*rem[5,1] + (NEW.STATE=="100 1")*rem[5,2] + (NEW.STATE=="100 2")*rem[5,3] + (NEW.STATE=="101 0")*rem[6,1] + (NEW.STATE=="101 1")*rem[6,2] + (NEW.STATE=="101 2")*rem[6,3] + (NEW.STATE=="110 0")*rem[7,1] + (NEW.STATE=="110 1")*rem[7,2] + (NEW.STATE=="110 2")*rem[7,3] + (NEW.STATE=="111 0")*rem[8,1] + (NEW.STATE=="111 1")*rem[8,2] + (NEW.STATE=="111 2")*rem[8,3])
  
  # Determine whether each start is "quality", or above average
  pitch <- mutate(pitch, QS = 1*(rem[1,1]*INN_CT > (RA + ERC)))
  
  # Determine the number of runs allowed above or below average
  pitch <- mutate(pitch, dRA = (rem[1,1]*INN_CT - (RA + ERC)))
  
  # Award credit for a Game Start, duh...
  pitch <- mutate(pitch, GS = 1)
  
  # Add tag to end of player ID to identify specific season
  pitch <- mutate(pitch, label = tag)
  pitch <- unite(pitch, PID, SP.ID, label, sep="", remove=TRUE)
  
  # Compute total quality starts over season for each pitcher,
  # as well as quality start rate and average dRA
  pitch <- pitch %>% group_by(PID) %>% summarise(Year = season,
                                                 GS = sum(GS),
                                                 eQS = sum(QS),
                                                 APPS = round(mean(dRA),3),
                                                 FInn = sum(dRA)/rem[1,1])
  pitch$FInn <- sign(pitch$FInn)*(floor(3*(abs(pitch$FInn)-floor(abs(pitch$FInn))))/10 + abs(floor(pitch$FInn)))
  pitch <- arrange(pitch,-eQS)
  pitch$eQSrate <- round(100*pitch$eQS/pitch$GS,2)
  
  # Output
  pitch
}
