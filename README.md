# run_analysis
=============================

Assignment Week 3 - Getting and Cleaning Data Course

The purpose of this project is to demonstrate the ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. The data was collected by Jorge L. Reyes-Ortiz, David Anguita, Alessandro Ghio and Luca Oneto from Smartlab www.smartlab.ws. The data was collected from 30 volunteers using smartphones and includes six activities (walking, walking upstairs, walking downstairs, sitting, standing and laying). The data were split into two sets, test and train.

There are two files in this repository:

* run_analysis.R
* CodeBook.md


##run_analysis.R

This file includes all the required scripts to download and process the files and then saves the tidy datasets.

 Merges the training and the test sets to create one data set.
* Extracts only the measurements on the mean and standard deviation for each measurement. 
* Uses descriptive activity names to name the activities in the data set
* Appropriately labels the data set with descriptive activity names. 
* Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
 
Packages required

* plyr
* reshape
 
Version of R used
3.1.2 (2014-10-31) --"Pumpkin Helmet"


##CodeBook.md

This file will explain different steps of the script. 
