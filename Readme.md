### Coursera Getting and Cleaning Data course project file repository:

This repository contains the following files in completion of the Getting and Cleaning Data final project. The required files are:

1.  `Codebook.md` is a code book that describes the data, variables, and the transformations or other work performed to clean up the data.

2.  `run_analysis.R` is the R code file containng all the scripts necessary to reproduce the tidy data set.

3.  `tidydataset.txt` is the tidy data file produced by running the R code.

4.  This `Readme.md` file which will explain the R scripts.

Setup R and install needed packages
-----------------------------------

Download the data file
----------------------

``` r
## Download the data file
## File will download to a directory called "data" in the working directory and unzipped; the actual data files will be in sub-directory "UCI HAR Dataset".
## Un-comment and use the next four files only of the dataset is not already downloaded in your
## working directory:
## if(!file.exists("./data")) {dir.create("./data")}
## fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
## download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")
## unzip(zipfile="./data/Dataset.zip",exdir="./data")
```

Read the data into R
--------------------

``` r
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

Step 1: Merge the training and the test sets to create one data set
-------------------------------------------------------------------

``` r
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
```

    ## [1] 10299   563

``` r
head(mergeddata[1:5])
```

    ##   subject activity tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z
    ## 1       2        5         0.2571778       -0.02328523       -0.01465376
    ## 2       2        5         0.2860267       -0.01316336       -0.11908252
    ## 3       2        5         0.2754848       -0.02605042       -0.11815167
    ## 4       2        5         0.2702982       -0.03261387       -0.11752018
    ## 5       2        5         0.2748330       -0.02784779       -0.12952716
    ## 6       2        5         0.2792199       -0.01862040       -0.11390197

Step 2: Extract only the measurements on the mean and standard deviation for each measurement
---------------------------------------------------------------------------------------------

``` r
## Step 2: Extract only the measurements on the mean and standard deviation for each measurement.
## Find the variable names with "mean" or "std"; note that looking through features.txt reveals that some means are spelled with an uppercase "M" and some with a lowercase 'm', although all the standard deviations are recorded as "std".
nameslist <- grep("std|[Mm]ean", features$V2, value = TRUE)
length(nameslist)
```

    ## [1] 86

``` r
##
## reduce the mergeddata file to only the mean and standard deviation measurements (keeping subject and activity variables)
mergeddata <- mergeddata[,c('subject', 'activity', nameslist)]
dim(mergeddata)
```

    ## [1] 10299    88

``` r
head(mergeddata[1:5])
```

    ##   subject activity tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z
    ## 1       2        5         0.2571778       -0.02328523       -0.01465376
    ## 2       2        5         0.2860267       -0.01316336       -0.11908252
    ## 3       2        5         0.2754848       -0.02605042       -0.11815167
    ## 4       2        5         0.2702982       -0.03261387       -0.11752018
    ## 5       2        5         0.2748330       -0.02784779       -0.12952716
    ## 6       2        5         0.2792199       -0.01862040       -0.11390197

Step 3: Use descriptive activity names to name the activities in the data set
-----------------------------------------------------------------------------

``` r
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
```

    ##   subject activity tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z
    ## 1       2 Standing         0.2571778       -0.02328523       -0.01465376
    ## 2       2 Standing         0.2860267       -0.01316336       -0.11908252
    ## 3       2 Standing         0.2754848       -0.02605042       -0.11815167
    ## 4       2 Standing         0.2702982       -0.03261387       -0.11752018
    ## 5       2 Standing         0.2748330       -0.02784779       -0.12952716
    ## 6       2 Standing         0.2792199       -0.01862040       -0.11390197

``` r
levels(mergeddata$activity)
```

    ## [1] "Walking"            "Walking_upstairs"   "Walking_downstairs"
    ## [4] "Sitting"            "Standing"           "Laying"

Step 4: Label the data set with descriptive variable names
----------------------------------------------------------

``` r
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

    ##  [1] "subject"                                       
    ##  [2] "activity"                                      
    ##  [3] "tBodyAccelerometerMean-X"                      
    ##  [4] "tBodyAccelerometerMean-Y"                      
    ##  [5] "tBodyAccelerometerMean-Z"                      
    ##  [6] "tBodyAccelerometerSTD-X"                       
    ##  [7] "tBodyAccelerometerSTD-Y"                       
    ##  [8] "tBodyAccelerometerSTD-Z"                       
    ##  [9] "tGravityAccelerometerMean-X"                   
    ## [10] "tGravityAccelerometerMean-Y"                   
    ## [11] "tGravityAccelerometerMean-Z"                   
    ## [12] "tGravityAccelerometerSTD-X"                    
    ## [13] "tGravityAccelerometerSTD-Y"                    
    ## [14] "tGravityAccelerometerSTD-Z"                    
    ## [15] "tBodyAccelerometerJerkMean-X"                  
    ## [16] "tBodyAccelerometerJerkMean-Y"                  
    ## [17] "tBodyAccelerometerJerkMean-Z"                  
    ## [18] "tBodyAccelerometerJerkSTD-X"                   
    ## [19] "tBodyAccelerometerJerkSTD-Y"                   
    ## [20] "tBodyAccelerometerJerkSTD-Z"                   
    ## [21] "tBodyGyroscopeMean-X"                          
    ## [22] "tBodyGyroscopeMean-Y"                          
    ## [23] "tBodyGyroscopeMean-Z"                          
    ## [24] "tBodyGyroscopeSTD-X"                           
    ## [25] "tBodyGyroscopeSTD-Y"                           
    ## [26] "tBodyGyroscopeSTD-Z"                           
    ## [27] "tBodyGyroscopeJerkMean-X"                      
    ## [28] "tBodyGyroscopeJerkMean-Y"                      
    ## [29] "tBodyGyroscopeJerkMean-Z"                      
    ## [30] "tBodyGyroscopeJerkSTD-X"                       
    ## [31] "tBodyGyroscopeJerkSTD-Y"                       
    ## [32] "tBodyGyroscopeJerkSTD-Z"                       
    ## [33] "tBodyAccelerometerMagnitudeMean"               
    ## [34] "tBodyAccelerometerMagnitudeSTD"                
    ## [35] "tGravityAccelerometerMagnitudeMean"            
    ## [36] "tGravityAccelerometerMagnitudeSTD"             
    ## [37] "tBodyAccelerometerJerkMagnitudeMean"           
    ## [38] "tBodyAccelerometerJerkMagnitudeSTD"            
    ## [39] "tBodyGyroscopeMagnitudeMean"                   
    ## [40] "tBodyGyroscopeMagnitudeSTD"                    
    ## [41] "tBodyGyroscopeJerkMagnitudeMean"               
    ## [42] "tBodyGyroscopeJerkMagnitudeSTD"                
    ## [43] "fBodyAccelerometerMean-X"                      
    ## [44] "fBodyAccelerometerMean-Y"                      
    ## [45] "fBodyAccelerometerMean-Z"                      
    ## [46] "fBodyAccelerometerSTD-X"                       
    ## [47] "fBodyAccelerometerSTD-Y"                       
    ## [48] "fBodyAccelerometerSTD-Z"                       
    ## [49] "fBodyAccelerometerMeanFrequency-X"             
    ## [50] "fBodyAccelerometerMeanFrequency-Y"             
    ## [51] "fBodyAccelerometerMeanFrequency-Z"             
    ## [52] "fBodyAccelerometerJerkMean-X"                  
    ## [53] "fBodyAccelerometerJerkMean-Y"                  
    ## [54] "fBodyAccelerometerJerkMean-Z"                  
    ## [55] "fBodyAccelerometerJerkSTD-X"                   
    ## [56] "fBodyAccelerometerJerkSTD-Y"                   
    ## [57] "fBodyAccelerometerJerkSTD-Z"                   
    ## [58] "fBodyAccelerometerJerkMeanFrequency-X"         
    ## [59] "fBodyAccelerometerJerkMeanFrequency-Y"         
    ## [60] "fBodyAccelerometerJerkMeanFrequency-Z"         
    ## [61] "fBodyGyroscopeMean-X"                          
    ## [62] "fBodyGyroscopeMean-Y"                          
    ## [63] "fBodyGyroscopeMean-Z"                          
    ## [64] "fBodyGyroscopeSTD-X"                           
    ## [65] "fBodyGyroscopeSTD-Y"                           
    ## [66] "fBodyGyroscopeSTD-Z"                           
    ## [67] "fBodyGyroscopeMeanFrequency-X"                 
    ## [68] "fBodyGyroscopeMeanFrequency-Y"                 
    ## [69] "fBodyGyroscopeMeanFrequency-Z"                 
    ## [70] "fBodyAccelerometerMagnitudeMean"               
    ## [71] "fBodyAccelerometerMagnitudeSTD"                
    ## [72] "fBodyAccelerometerMagnitudeMeanFrequency"      
    ## [73] "fBodyAccelerometerJerkMagnitudeMean"           
    ## [74] "fBodyAccelerometerJerkMagnitudeSTD"            
    ## [75] "fBodyAccelerometerJerkMagnitudeMeanFrequency"  
    ## [76] "fBodyGyroscopeMagnitudeMean"                   
    ## [77] "fBodyGyroscopeMagnitudeSTD"                    
    ## [78] "fBodyGyroscopeMagnitudeMeanFrequency"          
    ## [79] "fBodyGyroscopeJerkMagnitudeMean"               
    ## [80] "fBodyGyroscopeJerkMagnitudeSTD"                
    ## [81] "fBodyGyroscopeJerkMagnitudeMeanFrequency"      
    ## [82] "angle(tBodyAccelerometerMean,gravity)"         
    ## [83] "angle(tBodyAccelerometerJerkMean),gravityMean)"
    ## [84] "angle(tBodyGyroscopeMean,gravityMean)"         
    ## [85] "angle(tBodyGyroscopeJerkMean,gravityMean)"     
    ## [86] "angle(X,gravityMean)"                          
    ## [87] "angle(Y,gravityMean)"                          
    ## [88] "angle(Z,gravityMean)"

Step 5: From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject
----------------------------------------------------------------------------------------------------------------------------------------------------

``` r
## Step 5: From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.
mergeddata2 <- group_by(mergeddata, subject, activity)
mergeddata2 <- summarise_each(mergeddata2, funs(mean))
dim(mergeddata2)
```

    ## [1] 180  88

``` r
head(mergeddata2[1:3], 20)
```

    ## Source: local data frame [20 x 3]
    ## Groups: subject [4]
    ## 
    ##    subject           activity tBodyAccelerometerMean-X
    ##      (int)             (fctr)                    (dbl)
    ## 1        1            Walking                0.2773308
    ## 2        1   Walking_upstairs                0.2554617
    ## 3        1 Walking_downstairs                0.2891883
    ## 4        1            Sitting                0.2612376
    ## 5        1           Standing                0.2789176
    ## 6        1             Laying                0.2215982
    ## 7        2            Walking                0.2764266
    ## 8        2   Walking_upstairs                0.2471648
    ## 9        2 Walking_downstairs                0.2776153
    ## 10       2            Sitting                0.2770874
    ## 11       2           Standing                0.2779115
    ## 12       2             Laying                0.2813734
    ## 13       3            Walking                0.2755675
    ## 14       3   Walking_upstairs                0.2608199
    ## 15       3 Walking_downstairs                0.2924235
    ## 16       3            Sitting                0.2571976
    ## 17       3           Standing                0.2800465
    ## 18       3             Laying                0.2755169
    ## 19       4            Walking                0.2785820
    ## 20       4   Walking_upstairs                0.2708767

``` r
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
