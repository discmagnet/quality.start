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

library(ggplot2)
library(ggpubr)
# ERA versus eQSrate
plot1 <- ggplot(eQS_all) + 
  geom_point(aes(x = eQSrate, y = ERA)) + 
  geom_smooth(aes(x = eQSrate, y = ERA), se = FALSE) +
  labs(title = "Relationship between ERA and eQS Conversion Rate",
       subtitle = "with locally weighted scatterplot smoothing (LOESS)",
       x = "Enhanced Quality Start Conversion Rate (%)",
       y = "Earned Run Average") +
  theme_gray()
# ERA versus QSrate
plot2 <- ggplot(eQS_all) + 
  geom_point(aes(x = QS/GS.x, y = ERA)) + 
  geom_smooth(aes(x = QS/GS.x, y = ERA), se = FALSE) +
  labs(title = "Relationship between ERA and QS Conversion Rate",
       subtitle = "with locally weighted scatterplot smoothing (LOESS)",
       x = "Quality Start Conversion Rate (%)",
       y = "Earned Run Average") +
  theme_gray()

source('~/WORKING_DIRECTORIES/quality.start/user_defined_functions/outs2dec.R')
eQS_all2 <- eQS_all %>% mutate(IPthresh = as.integer(outs2dec(IP)/GS.x > 6))
# Repeat of plot1, but split into groups based on Average IP
plot3 <- ggplot(eQS_all2) + 
  geom_point(aes(x = eQSrate, y = ERA, color = factor(IPthresh), alpha = 0.8)) + 
  geom_smooth(aes(x = eQSrate, y = ERA, color = factor(IPthresh)), se = FALSE) +
  labs(title = "Relationship between ERA and eQS Conversion Rate",
       subtitle = "with locally weighted scatterplot smoothing (LOESS)",
       x = "Enhanced Quality Start Conversion Rate (%)",
       y = "Earned Run Average") +
  guides(alpha = "none", color = "legend") +
  scale_color_discrete(name = "Average IP", labels = c("Under 6","At least 6")) + 
  theme_gray()
# Repeat of plot2, but split into groups based on Average IP
plot4 <- ggplot(eQS_all2) + 
  geom_point(aes(x = QS/GS.x, y = ERA, color = factor(IPthresh), alpha = 0.8)) + 
  geom_smooth(aes(x = QS/GS.x, y = ERA, color = factor(IPthresh)), se = FALSE) +
  labs(title = "Relationship between ERA and QS Conversion Rate",
       subtitle = "with locally weighted scatterplot smoothing (LOESS)",
       x = "Quality Start Conversion Rate (%)",
       y = "Earned Run Average") +
  guides(alpha = "none", color = "legend") +
  scale_color_discrete(name = "Average IP", labels = c("Under 6","At least 6")) + 
  theme_gray()
# ERA versus APPS
plot5 <- ggplot(eQS_all) + 
  geom_point(aes(x = APPS, y = ERA)) + 
  geom_smooth(aes(x = APPS, y = ERA), se = FALSE) +
  labs(title = "Relationship between ERA and APPS",
       subtitle = "with locally weighted scatterplot smoothing (LOESS)",
       x = "Average Pitching Performance Score",
       y = "Earned Run Average") +
  theme_gray()
# WAR versus FInn
plot6 <- ggplot(eQS_all) + 
  geom_point(aes(x = FInn, y = WAR)) + 
  geom_smooth(aes(x = FInn, y = WAR), se = FALSE) +
  labs(title = "Relationship between WAR and FInn",
       subtitle = "with locally weighted scatterplot smoothing (LOESS)",
       x = "Free Innings",
       y = "Wins Above Replacement") +
  theme_gray()

# R-squared values between eQSrate and various pitching statistics
cor(eQS_all$eQSrate, eQS_all$ERA)^2                                # 0.670
cor(eQS_all$eQSrate, eQS_all$AVG)^2                                # 0.430
cor(eQS_all$eQSrate, eQS_all$WHIP)^2                               # 0.534
cor(eQS_all$eQSrate, eQS_all$WAR)^2                                # 0.439
cor(eQS_all$eQSrate, eQS_all$xFIP)^2                               # 0.228
cor(eQS_all$eQSrate, eQS_all$WPA)^2                                # 0.706
cor(eQS_all$eQSrate, eQS_all$RE24)^2                               # 0.723
cor(eQS_all$eQSrate, eQS_all$`K/9`)^2                              # 0.150
cor(eQS_all$eQSrate, eQS_all$W/(eQS_all$W + eQS_all$L))^2          # 0.349
# Corresponding R-squared values involving QS conversion rate
cor(eQS_all$QS/eQS_all$GS.x, eQS_all$ERA)^2                        # 0.588        
cor(eQS_all$QS/eQS_all$GS.x, eQS_all$AVG)^2                        # 0.327
cor(eQS_all$QS/eQS_all$GS.x, eQS_all$WHIP)^2                       # 0.502
cor(eQS_all$QS/eQS_all$GS.x, eQS_all$WAR)^2                        # 0.458
cor(eQS_all$QS/eQS_all$GS.x, eQS_all$xFIP)^2                       # 0.301
cor(eQS_all$QS/eQS_all$GS.x, eQS_all$WPA)^2                        # 0.539
cor(eQS_all$QS/eQS_all$GS.x, eQS_all$RE24)^2                       # 0.545
cor(eQS_all$QS/eQS_all$GS.x, eQS_all$`K/9`)^2                      # 0.086
cor(eQS_all$QS/eQS_all$GS.x, eQS_all$W/(eQS_all$W + eQS_all$L))^2  # 0.283

thresh_met <- eQS_all2 %>% subset(IPthresh == 1)
# R-squared values between eQSrate and various pitching statistics
cor(thresh_met$eQSrate, thresh_met$ERA)^2                                              # 0.650
cor(thresh_met$eQSrate, thresh_met$AVG)^2                                              # 0.431
cor(thresh_met$eQSrate, thresh_met$WHIP)^2                                             # 0.494
cor(thresh_met$eQSrate, thresh_met$WAR)^2                                              # 0.386
cor(thresh_met$eQSrate, thresh_met$xFIP)^2                                             # 0.220
cor(thresh_met$eQSrate, thresh_met$WPA)^2                                              # 0.665
cor(thresh_met$eQSrate, thresh_met$RE24)^2                                             # 0.685
cor(thresh_met$eQSrate, thresh_met$`K/9`)^2                                            # 0.213
cor(thresh_met$eQSrate, thresh_met$W/(thresh_met$W + thresh_met$L))^2                  # 0.301
# Corresponding R-squared values involving QS conversion rate
cor(thresh_met$QS/thresh_met$GS.x, thresh_met$ERA)^2                                   # 0.587        
cor(thresh_met$QS/thresh_met$GS.x, thresh_met$AVG)^2                                   # 0.338
cor(thresh_met$QS/thresh_met$GS.x, thresh_met$WHIP)^2                                  # 0.432
cor(thresh_met$QS/thresh_met$GS.x, thresh_met$WAR)^2                                   # 0.387
cor(thresh_met$QS/thresh_met$GS.x, thresh_met$xFIP)^2                                  # 0.243
cor(thresh_met$QS/thresh_met$GS.x, thresh_met$WPA)^2                                   # 0.511
cor(thresh_met$QS/thresh_met$GS.x, thresh_met$RE24)^2                                  # 0.523
cor(thresh_met$QS/thresh_met$GS.x, thresh_met$`K/9`)^2                                 # 0.161
cor(thresh_met$QS/thresh_met$GS.x, thresh_met$W/(thresh_met$W + thresh_met$L))^2       # 0.268

thresh_nmet <- eQS_all2 %>% subset(IPthresh == 0)
# R-squared values between eQSrate and various pitching statistics
cor(thresh_nmet$eQSrate, thresh_nmet$ERA)^2                                            # 0.455
cor(thresh_nmet$eQSrate, thresh_nmet$AVG)^2                                            # 0.204
cor(thresh_nmet$eQSrate, thresh_nmet$WHIP)^2                                           # 0.276
cor(thresh_nmet$eQSrate, thresh_nmet$WAR)^2                                            # 0.177
cor(thresh_nmet$eQSrate, thresh_nmet$xFIP)^2                                           # 0.007
cor(thresh_nmet$eQSrate, thresh_nmet$WPA)^2                                            # 0.560
cor(thresh_nmet$eQSrate, thresh_nmet$RE24)^2                                           # 0.579
cor(thresh_nmet$eQSrate, thresh_nmet$`K/9`)^2                                          # 0.051
cor(thresh_nmet$eQSrate, thresh_nmet$W/(thresh_nmet$W + thresh_nmet$L))^2              # 0.228
# Corresponding R-squared values involving QS conversion rate
cor(thresh_nmet$QS/thresh_nmet$GS.x, thresh_nmet$ERA)^2                                # 0.156        
cor(thresh_nmet$QS/thresh_nmet$GS.x, thresh_nmet$AVG)^2                                # 0.061
cor(thresh_nmet$QS/thresh_nmet$GS.x, thresh_nmet$WHIP)^2                               # 0.124
cor(thresh_nmet$QS/thresh_nmet$GS.x, thresh_nmet$WAR)^2                                # 0.101
cor(thresh_nmet$QS/thresh_nmet$GS.x, thresh_nmet$xFIP)^2                               # 0.030
cor(thresh_nmet$QS/thresh_nmet$GS.x, thresh_nmet$WPA)^2                                # 0.152
cor(thresh_nmet$QS/thresh_nmet$GS.x, thresh_nmet$RE24)^2                               # 0.144
cor(thresh_nmet$QS/thresh_nmet$GS.x, thresh_nmet$`K/9`)^2                              # 0.010
cor(thresh_nmet$QS/thresh_nmet$GS.x, thresh_nmet$W/(thresh_nmet$W + thresh_nmet$L))^2  # 0.067