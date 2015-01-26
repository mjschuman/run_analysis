##  This script downloads a zip file containing measurements from wearable computing devices 
##   and extracts the mean and standard deviation for each measurement 

##  Set the working directory and install libraries of all required packages.
setwd("~/.")
library(dplyr)
library(tidyr)
library(data.table)

##  Loads data if does not already exist.

if(!file.exists("./data")){
    file_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "    
    dir.create("data", recursive=FALSE,showWarnings=TRUE)
    download.file(file_url, destfile = "./data/dataset.zip", mode="wb")
    dateDownloaded <- date()
}
##
##  Set dataset path and load data and combine into single dataset
path <- path.expand("~/data")
##

## Get descriptive column heading names and activity labels
headings <- read.table(path,files=c("UCI HAR Dataset/features.txt"),
                       stringsAsFactors=FALSE, col.names=c("head_id","value"))
variables <- c((headings$value %like% "mean"& 
                    !(headings$value %like% "meanFreq"))| 
                   headings$value %like% "std()")
labels <- read.table(path,files=c("UCI HAR Dataset/activity_labels.txt"),
                     stringsAsFactors=FALSE, col.names=c("id","activity"))
##
##  Determine variable classes, and process data.
##
initial <- read.table(path,files=c("UCI HAR Dataset/test/X_test.txt"), nrows =1)
classes <- sapply(initial, class)
  
combinedSubjects <- rbind(read.table9(path,files=c("UCI HAR Dataset/test/subject_test.txt")9),
                     stringsAsFactors=FALSE, 
                     col.names=c("subject_id")),
                    read.table(path,files=c("UCI HAR Dataset/train/subject_train.txt"),
                        stringsAsFactors=FALSE, 
                        col.names=c("subject_id")))


combinedLabels <- merge(labels,
                    rbind(read.table(path,files=c("UCI HAR Dataset/test/y_test.txt"),
                            stringsAsFactors=FALSE, col.names=c("id")),
                          read.table(unzip(path,files=c("UCI HAR Dataset/train/y_train.txt")),
                            stringsAsFactors=FALSE, col.names=c("id"))),by.x="id",by.y="id")   

combinedData <- data.table(cbind(combinedLabels,combinedSubjects,
                      as.data.frame
                          (rbind(read.table(path,files=c("UCI HAR Dataset/test/X_test.txt"),
                                                colClasses = classes,
                                                stringsAsFactors=FALSE, 
                                                col.names=c(headings$value)),
                                 read.table(path,files=c("UCI HAR Dataset/train/X_train.txt"),
                                                colClasses = classes,
                                                stringsAsFactors=FALSE,
                                                col.names=c(headings$value))))[,variables]))

combinedDataGroup <- combinedData %>%
                        gather(measurement,value, -id, -activity, -subject_id) %>%
                        separate(measurement,c("feature","measure","axis")) %>%
                        group_by(id, activity,subject_id, feature, measure,axis) %>%      
                        summarize(avg=mean(value)) %>%
                        spread(measure,avg) 

##
##  Create TidyDataSet file in working directory.
##                        
write.table(combinedDataGroup,file="./TidyDataSet.txt", row.names=FALSE)
  
