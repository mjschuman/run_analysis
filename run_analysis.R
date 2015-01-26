##  This script downloads a zip file containing measurements from wearable computing devices 
##   and extracts the mean and standard deviation for each measurement 

##  Set the working directory and install libraries of all required packages.
setwd("~/.")
library(dplyr)
library(tidyr)
library(data.table)
library(reshape2)

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
folder_dir <-'UCI HAR Dataset'
test_dir <-paste(path, 'UCI HAR Dataset/test/', sep='/')
train_dir <- paste(path, 'UCI HAR Dataset/train/', sep='/')
features <- read.table(paste(path,folder_dir, 'features.txt' sep='/'))
labels <- read.table(paste(path, folder.dir, 'activity_labels.txt', sep = '/'))

train_x     <- read.table(paste(train.path, 'X_train.txt', sep = ''))
test_x      <- read.table(paste(test.path, 'X_test.txt', sep = ''))
train_y     <- read.table(paste(train.path, 'y_train.txt', sep = ''))
test_y      <- read.table(paste(test.path, 'y_test.txt', sep = ''))
test_subj   <- read.table(paste(test.path, 'subject_test.txt', sep = ''))
train_subj  <- read.table(paste(train.path, 'subject_train.txt', sep = ''))

subj <- rbind(test_subj, train_subj)
colnames(subj) <- 'subject'


merge_activity <- rbind(test_y, train_y)
merge_activity <- merge(merge_activity, labels, by=1)[,2]


merge_x <- rbind(test_x, train_x)
colnames(merge_x) <- features[, 2]


merge_all <- cbind(subj, merge_activity, merge_x)


merge_all_stat <- merge_all[ ,c(1, 2, grep('-mean|-std', colnames(merge_all)))]

## ---- compute means grouped by subject and activity
melt_data = melt(merge_all_stat, id.var = c('subject', 'activity'))
mean_stat = dcast(melt_data , subject + activity ~ variable, mean)

##
##  Create TidyDataSet file in working directory.
##                        
write.table(mean_stat,file="TidyDataSet.txt", row.names=FALSE)
  
