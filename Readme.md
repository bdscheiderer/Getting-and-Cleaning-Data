---
title: "Readme"
subtitle: "Getting and Cleaning Data - Final Project"
date: July 20, 2016
output: 
  md_document:
    variant: markdown_github
---
### Coursera Getting and Cleaning Data course project file repository:

This repository contains the following files in completion of the Getting and Cleaning Data final project. The required files are: 

1. `Codebook.md` is a code book that describes the data, variables, and the transformations or other work performed to clean up the data.

2. `run_analysis.R` is the R code file containng all the scripts necessary to reproduce the tidy data set.

3. `tidydataset.txt` is the tidy data file produced by running the R code.

4. This `Readme.md` file which will explain the R scripts.


## Setup R and install needed packages
```{r setup, include=FALSE}
## Setup R and install needed packages
knitr::opts_chunk$set(echo = TRUE)
library(dplyr)
library(reshape2)
```
  
## Download the data file
```{r}
## Download the data file
## File will download to a directory called "data" in the working directory and unzipped; the actual data files will be in sub-directory "UCI HAR Dataset".
## Un-comment and use the next four files only of the dataset is not already downloaded in your
## working directory:
## if(!file.exists("./data")) {dir.create("./data")}
## fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
## download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")
## unzip(zipfile="./data/Dataset.zip",exdir="./data")
```
  
## Read the data into R
```{r}
## Read the data into R
## 8 files will be read in from "./data/UCI HAR Dataset".
## This assumes the Sansung data file is already in the working directory.
subjecttest <- read.table('./UCI HAR Dataset/test/subject_test.txt')
xtest <- read.table('./UCI HAR Dataset/test/X_test.txt')
ytest <- read.table('./UCI HAR Dataset/test/y_test.txt')
subjecttrain <- read.table('./UCI HAR Dataset/train/subject_train.txt')
xtrain <- read.table('./UCI HAR Dataset/train/X_train.txt')
ytrain <- read.table('./UCI HAR Dataset/train/y_train.txt')
features <- read.table('./UCI HAR Dataset/features.txt', stringsAsFactors = FALSE)
activities <- read.table('./UCI HAR Dataset/activity_labels.txt')
```
  
## Step 1: Merge the training and the test sets to create one data set
```{r}
## Step 1: Merge the training and the test sets to create one data set.
test <- cbind(subjecttest, ytest, xtest)
train <- cbind(subjecttrain, ytrain, xtrain)
mergeddata <- rbind(test, train)
##
## rename column headings
names(mergeddata)[1] <- 'subject'
names(mergeddata)[2] <- 'activity'
names(mergeddata)[3:563] <- features$V2
##
## check the work so far:
dim(mergeddata)
head(mergeddata[1:5])
```
  
## Step 2: Extract only the measurements on the mean and standard deviation for each measurement
```{r}
## Step 2: Extract only the measurements on the mean and standard deviation for each measurement.
## Find the variable names with "mean" or "std"; note that looking through features.txt reveals that some means are spelled with an uppercase "M" and some with a lowercase 'm', although all the standard deviations are recorded as "std".
nameslist <- grep("std|[Mm]ean", features$V2, value = TRUE)
length(nameslist)
##
## reduce the mergeddata file to only the mean and standard deviation measurements (keeping subject and activity variables)
mergeddata <- mergeddata[,c('subject', 'activity', nameslist)]
dim(mergeddata)
head(mergeddata[1:5])
```
  
## Step 3: Use descriptive activity names to name the activities in the data set
```{r}
## Step 3: Use descriptive activity names to name the activities in the data set.
## Set the Actitivy column to a factor
mergeddata$activity <- as.factor(mergeddata$activity)
##
## Use the levels feature to change the factor levels in the Actitivy column to the names from the actitivy_levels.txt file
levels(mergeddata$activity)[levels(mergeddata$activity) == '1'] <- 'Walking'
levels(mergeddata$activity)[levels(mergeddata$activity) == '2'] <- 'Walking_upstairs'
levels(mergeddata$activity)[levels(mergeddata$activity) == '3'] <- 'Walking_downstairs'
levels(mergeddata$activity)[levels(mergeddata$activity) == '4'] <- 'Sitting'
levels(mergeddata$activity)[levels(mergeddata$activity) == '5'] <- 'Standing'
levels(mergeddata$activity)[levels(mergeddata$activity) == '6'] <- 'Laying'
##
## check the work so far
head(mergeddata[1:5])
levels(mergeddata$activity)
```
  
## Step 4: Label the data set with descriptive variable names
```{r}
## Step 4: Label the data set with descriptive variable names.
## This step I understand to mean to change the column labels to something more understandable, for example, the first measurement variable, column 3, is "tBodyAcc-mean()-X", which would be more readable as "TimeBodyAccelerometerMean-X". I will leave the prefixes "t" = 'time" and "f" = "frequency" in place as they are explained in the features text file, however, I will make the following substitions:
names(mergeddata)<-gsub('Acc', 'Accelerometer', names(mergeddata))
names(mergeddata)<-gsub('Freq', 'Frequency', names(mergeddata))
names(mergeddata)<-gsub('\\-meanFrequency\\(\\)', 'MeanFrequency',  names(mergeddata))
names(mergeddata)<-gsub('Gyro', 'Gyroscope', names(mergeddata))
names(mergeddata)<-gsub('Mag', 'Magnitude', names(mergeddata))
names(mergeddata)<-gsub('\\-mean\\(\\)', 'Mean', names(mergeddata))
names(mergeddata)<-gsub('\\-std\\(\\)', 'STD', names(mergeddata))
names(mergeddata)<-gsub('BodyBody', 'Body', names(mergeddata))
##
## check the work
names(mergeddata)
```
  
## Step 5: From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject
```{r}
## Step 5: From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.
mergeddata2 <- group_by(mergeddata, subject, activity)
mergeddata2 <- summarise_each(mergeddata2, funs(mean))
dim(mergeddata2)
head(mergeddata2[1:3], 20)
##
## The mergeddata2 data frame now contains the mean for each variable for each fo the six actitives, for each of the 30 subjects; now the final step to write the result to a file named 'tidydataset.txt".
##write.table(mergeddata2, file = "tidydataset.txt",row.name=FALSE)
##
## Note: I decided to keep the data in "wide" format based upon this post cited in the discussion forums: 
## https://thoughtfulbloke.wordpress.com/2015/09/09/getting-and-cleaning-the-assignment/
##
## The following code should allow a reader to read in this tidy data set and view the data:
## data <- read.table('./tidydataset.txt', header = TRUE)
## View(data)
```
  
**END**

