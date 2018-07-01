# Import Data ----
# Use the quality.R function to obtain eQS data
source('~/WORKING_DIRECTORIES/quality.start/quality.R')
# eQS11 <- quality(2011,"")
# eQS12 <- quality(2012,"")
# eQS13 <- quality(2013,"")
# eQS14 <- quality(2014,"")
# eQS15 <- quality(2015,"")
# eQS16 <- quality(2016,"")
# eQS17 <- quality(2017,"")
# Import roster files that contain player IDs used to join the data
library(readr)
roster2011 <- read_csv("~/WORKING_DIRECTORIES/quality.start/data/roster2011.csv")
roster2012 <- read_csv("~/WORKING_DIRECTORIES/quality.start/data/roster2012.csv")
roster2013 <- read_csv("~/WORKING_DIRECTORIES/quality.start/data/roster2013.csv")
roster2014 <- read_csv("~/WORKING_DIRECTORIES/quality.start/data/roster2014.csv")
roster2015 <- read_csv("~/WORKING_DIRECTORIES/quality.start/data/roster2015.csv")
roster2016 <- read_csv("~/WORKING_DIRECTORIES/quality.start/data/roster2016.csv")
roster2017 <- read_csv("~/WORKING_DIRECTORIES/quality.start/data/roster2017.csv")
# Import QS data
data_quality_starts <- read_delim("~/WORKING_DIRECTORIES/quality.start/data/data.quality.starts.csv", 
                                                         "\t", escape_double = FALSE, trim_ws = TRUE)
# Import data from Fangraphs
data_fangraphs <- read_csv("~/WORKING_DIRECTORIES/quality.start/data/data.fangraphs.csv")

# Clean Data ----
# Combine First.Name and Last.Name to create 'Name' used to join data
roster11_name <- mutate(roster2011, Name = paste(First.Name, " ", Last.Name, sep = ""))
roster12_name <- mutate(roster2012, Name = paste(First.Name, " ", Last.Name, sep = ""))
roster13_name <- mutate(roster2013, Name = paste(First.Name, " ", Last.Name, sep = ""))
roster14_name <- mutate(roster2014, Name = paste(First.Name, " ", Last.Name, sep = ""))
roster15_name <- mutate(roster2015, Name = paste(First.Name, " ", Last.Name, sep = ""))
roster16_name <- mutate(roster2016, Name = paste(First.Name, " ", Last.Name, sep = ""))
roster17_name <- mutate(roster2017, Name = paste(First.Name, " ", Last.Name, sep = ""))
# Remove Periods in Names (for example, A.J. to AJ)
roster11_name$Name <- gsub(".","",roster11_name$Name,fixed=TRUE)
roster12_name$Name <- gsub(".","",roster12_name$Name,fixed=TRUE)
roster13_name$Name <- gsub(".","",roster13_name$Name,fixed=TRUE)
roster14_name$Name <- gsub(".","",roster14_name$Name,fixed=TRUE)
roster15_name$Name <- gsub(".","",roster15_name$Name,fixed=TRUE)
roster16_name$Name <- gsub(".","",roster16_name$Name,fixed=TRUE)
roster17_name$Name <- gsub(".","",roster17_name$Name,fixed=TRUE)
data_fangraphs$Name <- gsub(".","",data_fangraphs$Name,fixed=TRUE)
data_quality_starts$Name <- gsub(".","",data_quality_starts$Name,fixed=TRUE)
# Rename Player.ID to 'PID' in order to join data
colnames(roster11_name)[2] <- "PID"
colnames(roster12_name)[2] <- "PID"
colnames(roster13_name)[2] <- "PID"
colnames(roster14_name)[2] <- "PID"
colnames(roster15_name)[2] <- "PID"
colnames(roster16_name)[2] <- "PID"
colnames(roster17_name)[2] <- "PID"

# Join Data ----
# Join player names to eQS data
eQS11_name <- left_join(eQS11,roster11_name,by="PID") %>%
  group_by(Name) %>% summarise_all(first)
eQS12_name <- left_join(eQS12,roster12_name,by="PID") %>%
  group_by(Name) %>% summarise_all(first)
eQS13_name <- left_join(eQS13,roster13_name,by="PID") %>%
  group_by(Name) %>% summarise_all(first)
eQS14_name <- left_join(eQS14,roster14_name,by="PID") %>%
  group_by(Name) %>% summarise_all(first)
eQS15_name <- left_join(eQS15,roster15_name,by="PID") %>%
  group_by(Name) %>% summarise_all(first)
eQS16_name <- left_join(eQS16,roster16_name,by="PID") %>%
  group_by(Name) %>% summarise_all(first)
eQS17_name <- left_join(eQS17,roster17_name,by="PID") %>%
  group_by(Name) %>% summarise_all(first)
# Join QS data to previous
eQS11_name_qs <- inner_join(eQS11_name,subset(data_quality_starts,Year==2011),by="Name")
eQS12_name_qs <- inner_join(eQS12_name,subset(data_quality_starts,Year==2012),by="Name")
eQS13_name_qs <- inner_join(eQS13_name,subset(data_quality_starts,Year==2013),by="Name")
eQS14_name_qs <- inner_join(eQS14_name,subset(data_quality_starts,Year==2014),by="Name")
eQS15_name_qs <- inner_join(eQS15_name,subset(data_quality_starts,Year==2015),by="Name")
eQS16_name_qs <- inner_join(eQS16_name,subset(data_quality_starts,Year==2016),by="Name")
eQS17_name_qs <- inner_join(eQS17_name,subset(data_quality_starts,Year==2017),by="Name")
# Join Fangraphs data to previous
eQS11_name_qs_fan <- inner_join(eQS11_name_qs,subset(data_fangraphs,Season==2011),by="Name")
eQS12_name_qs_fan <- inner_join(eQS12_name_qs,subset(data_fangraphs,Season==2012),by="Name")
eQS13_name_qs_fan <- inner_join(eQS13_name_qs,subset(data_fangraphs,Season==2013),by="Name")
eQS14_name_qs_fan <- inner_join(eQS14_name_qs,subset(data_fangraphs,Season==2014),by="Name")
eQS15_name_qs_fan <- inner_join(eQS15_name_qs,subset(data_fangraphs,Season==2015),by="Name")
eQS16_name_qs_fan <- inner_join(eQS16_name_qs,subset(data_fangraphs,Season==2016),by="Name")
eQS17_name_qs_fan <- inner_join(eQS17_name_qs,subset(data_fangraphs,Season==2017),by="Name")

# Merge & Analyze Data ----
eQS_all <- bind_rows(eQS11_name_qs_fan,eQS12_name_qs_fan,eQS13_name_qs_fan,eQS14_name_qs_fan,
             eQS15_name_qs_fan,eQS16_name_qs_fan,eQS17_name_qs_fan)