### Coursera Getting and Cleaning Data course project file repository:

This repository contains the following files in completion of the Getting and Cleaning Data final project. The required files are:

1.  `Codebook.md` is a code book that describes the data, variables, and the transformations or other work performed to clean up the data.

2.  `run_analysis.R` is the R code file containing all the scripts necessary to reproduce the tidy data set.

3.  `tidydataset.txt` is the tidy data file produced by running the R code.

4.  This `README.md` file which will describe how the R scripts work to create the tidy data set.

Setup R and install needed packages
-----------------------------------

The initial step is to setup R and load the necessary packages.

``` r
## Setup R and install needed packages
knitr::opts_chunk$set(echo = TRUE)
library(dplyr)
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
library(reshape2)
```

Download the data file
----------------------

Next, I needed a script to download and unzip the data file into a sub-directory of the working directory.

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

Now that the raw data file has been downloaded and unzipped, the following script will read into R eight relevant data files that were in the zipped raw data. There are three data files for test measurements, three data files for train measurements, a data file explaining the activities, and a data file for the features (descriptive names of the measurements). Ensure the working directory is set correctly by using the **getwd()** and **setwd()** commands as necessary.

``` r
## Read the data into R
## 8 files will be read in from "./data/UCI HAR Dataset".
## This assumes the Sansung data file is already in the working directory.
subjecttest <- read.table('./data/UCI HAR Dataset/test/subject_test.txt')
xtest <- read.table('./data/UCI HAR Dataset/test/X_test.txt')
ytest <- read.table('./data/UCI HAR Dataset/test/y_test.txt')
subjecttrain <- read.table('./data/UCI HAR Dataset/train/subject_train.txt')
xtrain <- read.table('./data/UCI HAR Dataset/train/X_train.txt')
ytrain <- read.table('./data/UCI HAR Dataset/train/y_train.txt')
features <- read.table('./data/UCI HAR Dataset/features.txt', stringsAsFactors = FALSE)
activities <- read.table('./data/UCI HAR Dataset/activity_labels.txt')
```

Step 1: Merge the training and the test sets to create one data set
-------------------------------------------------------------------

Now, we are ready to actually start cleaning and tidying up the raw data. I decided to combine the columns first of the test measurements, activities and features, and then separately the train measurements, activities and features. Then, using the row binding command, "stacked" the two files to obtain one merged dataset called **mergeddata**. Finally, this script names the columns in the file, the first column is the 'subject' and the second is 'activity'. The remaining columns are the measurement variable names from the **features.txt** file.

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
```

Let's examine the **mergeddata** file that has been created.

``` r
class(mergeddata)
```

    ## [1] "data.frame"

``` r
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

We can confirm that **mergeddata** is a data.frame with 10299 observations of 563 variables. The head command showed us a few five variable columns, with the appropriate column names from the features file.

Step 2: Extract only the measurements on the mean and standard deviation for each measurement
---------------------------------------------------------------------------------------------

The script in the next step will extract the columns for certain variables we are looking for, specifically any measurement variable that is a mean or standard deviation. To do this, I created a list with all the names from the features file that match either 'std' or 'mean' or 'Mean'. The second script line then reduces the **mergeddata** file to only those columns matching the column names in the list of names (keeping of course the 'subject' and activity' variables)

``` r
## Step 2: Extract only the measurements on the mean and standard deviation for each measurement.
## Find the variable names with "mean" or "std"; note that looking through features.txt reveals that some means are spelled with an uppercase "M" and some with a lowercase 'm', although all the standard deviations are recorded as "std".
nameslist <- grep("std|[Mm]ean", features$V2, value = TRUE)
## reduce the mergeddata file to only the mean and standard deviation measurements (keeping subject and activity variables)
mergeddata <- mergeddata[,c('subject', 'activity', nameslist)]
```

Let's again examine the **mergeddata** file.

``` r
length(nameslist)
```

    ## [1] 86

``` r
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

We can see there are 86 variable names that are either a mean or standard deviation; and we confirm that our data.frame still has 10299 observations, but now with 88 variables (the 86 measurement variables, plus 'subject' and 'activity').

Step 3: Use descriptive activity names to name the activities in the data set
-----------------------------------------------------------------------------

Next, the assignment asked that we change the activities levels to the descriptive names. The first script line ensures that the **activity** variable in **mergeddata** is a factor. The factor has six levels, so the next lines of code change the levels from integers 1 through 6, to the descriptive names such as "Walking", "Standing", etc.

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
```

Again, a quick check of the **mergeddata** file to make certain the R code is working as intended.

``` r
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

Reviewing the **activity** column and the levels for the column indicate the changes have been made.

Step 4: Label the data set with descriptive variable names
----------------------------------------------------------

The next step of the assignment calls for changing the measurement variable names (the 86 variables containing mean or standard deviation values) to more understandable names. For example, the first measurement variable in the third column, "tBodyAcc-mean()-X", which would be more readable as "tBodyAccelerometerMean-X". I will leave the prefixes "t" = 'time" and "f" = "frequency" in place as they are explained in the features text file, however, I will make the following substitutions:

``` r
## Step 4: Label the data set with descriptive variable names.
## This step I understand to mean to change the column labels to something more understandable, for example, the first measurement variable, column 3, is "tBodyAcc-mean()-X", which would be more readable as "tBodyAccelerometerMean-X". I will leave the prefixes "t" = 'time" and "f" = "frequency" in place as they are explained in the features text file, however, I will make the following substitions:
names(mergeddata)<-gsub('Acc', 'Accelerometer', names(mergeddata))
names(mergeddata)<-gsub('Freq', 'Frequency', names(mergeddata))
names(mergeddata)<-gsub('\\-meanFrequency\\(\\)', 'MeanFrequency',  names(mergeddata))
names(mergeddata)<-gsub('Gyro', 'Gyroscope', names(mergeddata))
names(mergeddata)<-gsub('Mag', 'Magnitude', names(mergeddata))
names(mergeddata)<-gsub('\\-mean\\(\\)', 'Mean', names(mergeddata))
names(mergeddata)<-gsub('\\-std\\(\\)', 'STD', names(mergeddata))
names(mergeddata)<-gsub('BodyBody', 'Body', names(mergeddata))
```

Let's look at the 88 column names after the substitutions:

``` r
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

Everything looks good so on to the final step.

Step 5: From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject
----------------------------------------------------------------------------------------------------------------------------------------------------

The script will create a second data.frame by grouping the data, first by subject and then by activity. The next line will summarize the grouped data by calculating the mean for each variable. There were 30 subjects who it is assumed performed all 6 different activity tasks. Thus, I would expect the resulting **mergeddata2** file to contain 180 (30\*6) observations of the 86 variables (including 'subject' and 'activity', the resulting data frame should have dimensions of 180 x 88).

Note: I decided to keep the data in "wide" format based upon this post cited in the discussion forums: <https://thoughtfulbloke.wordpress.com/2015/09/09/getting-and-cleaning-the-assignment/>

``` r
## Step 5: From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.
mergeddata2 <- group_by(mergeddata, subject, activity)
mergeddata2 <- summarise_each(mergeddata2, funs(mean))
```

Checking the result one last time:

``` r
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

The dimensions of **mergeddata** are as expected, and the head of the data file indicates the proper grouping by subject, then activity, and the variable value is now the mean for that group.

The very last step is to write the clean and tidy data set **mergeddata2** to the file **tidydataset.txt**.

``` r
## The mergeddata2 data frame now contains the mean for each variable for each fo the six actitives, for each of the 30 subjects. Now the very last step to write the result to a file named 'tidydataset.txt".
write.table(mergeddata2, file = "tidydataset.txt",row.name=FALSE)
```

A final note: code to assist a reader in reading in the data file that was created by this script. Ensure that the file **tidydataset.txt** is in your working directory:

``` r
## The following code should allow a reader to read in this tidy data set and view the data:
## data <- read.table('./tidydataset.txt', header = TRUE)
## View(data)
```
