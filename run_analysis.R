## This R script, run_analysis.R, is the final project code for Getting and
## Cleaning Data, Coursera, July 2016
##
##
## Setup R and install needed packages for the functions used in this script
library(dplyr)
library(reshape2)
##
##
## Download the data file
##
## The raw data file will download to a sub-directory called "data" in the working directory 
## and unzipped. The actual data files will be in sub-directory "UCI HAR Dataset"
## Un-comment and run the next four lines if the data set is NOT already in the working directory.
## if(!file.exists("./data")) {dir.create("./data")}
## fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
## download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")
## unzip(zipfile="./data/Dataset.zip",exdir="./data")

## Read the data into R
##
## 8 files will be read in from the sub-directory "./UCI HAR Dataset"
## This assumes the Sansung data file is already in the working directory
subjecttest <- read.table('./UCI HAR Dataset/test/subject_test.txt')
xtest <- read.table('./UCI HAR Dataset/test/X_test.txt')
ytest <- read.table('./UCI HAR Dataset/test/y_test.txt')
subjecttrain <- read.table('./UCI HAR Dataset/train/subject_train.txt')
xtrain <- read.table('./UCI HAR Dataset/train/X_train.txt')
ytrain <- read.table('./UCI HAR Dataset/train/y_train.txt')
features <- read.table('./UCI HAR Dataset/features.txt', stringsAsFactors = FALSE)
activities <- read.table('./UCI HAR Dataset/activity_labels.txt')
##
##
## Step 1: Merge the training and the test sets to create one data set
##
## First, merge using the column bind command the test data, then the train data
test <- cbind(subjecttest, ytest, xtest)
train <- cbind(subjecttrain, ytrain, xtrain)
## Second, using row bind, merged 'test' and 'train' to create one data set called 'mergeddata'
mergeddata <- rbind(test, train)
## Rename column headings to 'subject', 'activity', and the 561 variable names from features.txt
names(mergeddata)[1] <- 'subject'
names(mergeddata)[2] <- 'activity'
names(mergeddata)[3:563] <- features$V2
##
##
## Step 2: Extract only the measurements on the mean and standard deviation
## for each measurement
##
## Find the variable names with "mean" or "std"; note that looking through 
## features.txt reveals that some means are spelled with an uppercase "M" 
## and some with a lowercase 'm', although all the standard deviations are recorded as "std".
nameslist <- grep("std|[Mm]ean", features$V2, value = TRUE)
length(nameslist)
##
## reduce the mergeddata file to only the mean and standard deviation measurements 
## (keeping subject and activity variables)
mergeddata <- mergeddata[,c('subject', 'activity', nameslist)]
##
##
## Step 3: Use descriptive activity names to name the activities in the data set
##
## Set the Activity column to a factor
mergeddata$activity <- as.factor(mergeddata$activity)
##
## Use the levels feature to change the factor levels in the Activity column to the 
## names from the activity_levels.txt file
levels(mergeddata$activity)[levels(mergeddata$activity) == '1'] <- 'Walking'
levels(mergeddata$activity)[levels(mergeddata$activity) == '2'] <- 'Walking_upstairs'
levels(mergeddata$activity)[levels(mergeddata$activity) == '3'] <- 'Walking_downstairs'
levels(mergeddata$activity)[levels(mergeddata$activity) == '4'] <- 'Sitting'
levels(mergeddata$activity)[levels(mergeddata$activity) == '5'] <- 'Standing'
levels(mergeddata$activity)[levels(mergeddata$activity) == '6'] <- 'Laying'
##
##
## Step 4: Label the data set with descriptive variable names
##
## This step I understand to mean to change the column labels to something more 
## understandable, for example, the first measurement variable, column 3, is 
## "tBodyAcc-mean()-X", which would be more readable as "TimeBodyAccelerometerMean-X". 
## I will leave the prefixes "t" = 'time" and "f" = "frequency" in place as they are 
## explained in the features text file.
names(mergeddata)<-gsub('Acc', 'Accelerometer', names(mergeddata))
names(mergeddata)<-gsub('Freq', 'Frequency', names(mergeddata))
names(mergeddata)<-gsub('\\-meanFrequency\\(\\)', 'MeanFrequency',  names(mergeddata))
names(mergeddata)<-gsub('Gyro', 'Gyroscope', names(mergeddata))
names(mergeddata)<-gsub('Mag', 'Magnitude', names(mergeddata))
names(mergeddata)<-gsub('\\-mean\\(\\)', 'Mean', names(mergeddata))
names(mergeddata)<-gsub('\\-std\\(\\)', 'STD', names(mergeddata))
names(mergeddata)<-gsub('BodyBody', 'Body', names(mergeddata))
##
##
## Step 5: From the data set in step 4, create a second, independent tidy data 
## set with the average of each variable for each activity and each subject
##
## Use the group_by function to group first by subject, then activity, then the 
## summarize command to calculate mean, created new data set called 'mergeddata2'
mergeddata2 <- group_by(mergeddata, subject, activity)
mergeddata2 <- summarise_each(mergeddata2, funs(mean))
##
## The mergeddata2 data frame now contains the mean for each variable for each of 
## the six actitives, for each of the 30 subjects; now the final step to write the 
## result to a file named 'tidydataset.txt"
write.table(mergeddata2, file = "tidydataset.txt",row.name=FALSE)
##
## The following code should allow a reader to read in this tidy date set and view 
## the data; this assumes tidydataset.txt is in the working directory:
## data <- read.table('./tidydataset.txt', header = TRUE)
## View(data)
##
## END