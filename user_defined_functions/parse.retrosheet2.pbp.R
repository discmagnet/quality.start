parse.retrosheet2.pbp = function(season){
# download, unzip, append retrosheet data
# assume current directory has a folder download.folder
# download.folder has two subfolders unzipped and zipped
# program cwevent.exe is in unzipped folder (for windows)

download.retrosheet <- function(season){
  # downloads the Retrosheet zip file from the particular season
  # and saves the zip file in the "zipped" folder
  download.file(
    url=paste("http://www.retrosheet.org/events/", season, "eve.zip", sep="")
    , destfile=paste("download.folder", "/zipped/", season, "eve.zip", sep="")
    )
}

unzip.retrosheet <- function(season){
  # unzips the file and puts the individual event files
  # and roster files in the "unzipped" folder
  unzip(paste("download.folder", "/zipped/", season, "eve.zip", sep=""), 
        exdir=paste("download.folder", "/unzipped", sep=""))
}

create.csv.file=function(year){
  # reads the individual team record files into R, merges the files,
  # and writes a new single combined file in csv format in the "unzipped" folder
  wd = getwd()
  setwd("download.folder/unzipped")
  if (.Platform$OS.type == "unix"){
  system(paste(paste("cwevent -y", year, "-f 0-96"), 
              paste(year,"*.EV*",sep=""),
              paste("> all", year, ".csv", sep="")))} else {
  shell(paste(paste("cwevent -y", year, "-f 0-96"), 
              paste(year,"*.EV*",sep=""),
              paste("> all", year, ".csv", sep="")))              
              }
  setwd(wd)
}

create.csv.roster = function(year){
  # creates a csv file of the rosters
  filenames <- list.files(path = "download.folder/unzipped/")
  filenames.roster = 
    subset(filenames, substr(filenames, 4, 11)==paste(year,".ROS",sep=""))
  read.csv2 = function(file)
    read.csv(paste("download.folder/unzipped/", file, sep=""),header=FALSE)
  R = do.call("rbind", lapply(filenames.roster, read.csv2))
  names(R)[1:6] = c("Player.ID", "Last.Name", "First.Name", 
                    "Bats", "Pitches", "Team")
  wd = getwd()
  setwd("download.folder/unzipped")
  write.csv(R, file=paste("roster", year, ".csv", sep=""))
  setwd(wd)
}

cleanup = function(){
  # removes the individual record and roster files that are no longer needed
  wd = getwd()
  setwd("download.folder/unzipped")
  if (.Platform$OS.type == "unix"){
     system("rm *.EVN")
     system("rm *.EVA")
     system("rm *.ROS")
     system("rm TEAM*")} else {
     shell("del *.EVN")
     shell("del *.EVA")
     shell("del *.ROS")
     shell("del TEAM*")
   }       
  setwd(wd)
  setwd("download.folder/zipped")
  if (.Platform$OS.type == "unix"){
    system("rm *.zip")} else {
    shell("del *.zip")
  }
  setwd(wd)
}
  download.retrosheet(season)
  unzip.retrosheet(season)
  create.csv.file(season)
  create.csv.roster(season)
  cleanup()
}