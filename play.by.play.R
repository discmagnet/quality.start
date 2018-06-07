play.by.play <- function(season){  
  # assume that files "allseason.csv" and "fields.csv"
  # are in current working folder
  # for example, if season = 1961, all1961.csv should be
  # available
  
  # returns play-by-play data
  
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
  
  playbyplay <- subset(data, (STATE!=NEW.STATE) | (RUNS.SCORED>0))
  
  playbyplay
}