### Introduction

This is the Code Book for the final project of the Coursera course Getting and Cleaning Data. The data used in this project is data collected from a human activity recognition project, specifically measurements from the accelerometers and gyroscope from the Samsung Galaxy S smartphone. Thirty volunteers were recorded while performing six different physical activities, all while wearing the smartphone at the waist. The raw data from the smartphone's accelerometer and gyroscope is 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz.A more detailed description of the raw data is found at: <http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>.

The purpose of this project was to clean up and tidy the raw data for analysis. The file "run\_analysis.R" contains the R scripts run to clean and tidy the Sansung data. The output is written to a file named "tidydataset.txt".

### General look at the tidydataset.txt file:

The data file is a data frame of 180 observations and 88 variables. Here is a look at the first ten rows and first three columns of the data:

    ##    subject           activity tBodyAccelerometerMean.X
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

### Description of the variables:

The variable **subject** in the first column is an integer ranging from 1 to 30, representing the subject number using the smartphone at the time the data was collected.

The variable **activity** in the second column is a factor with six levels, identifying the type of activity the subject was engaged in while the data was collected. The levels are 'Walking', 'Walking\_downstairs', 'Walking\_upstairs', 'Sitting', 'Standing', and 'Laying'.

The raw data set contained over 10,000 data observations of 561 variables. One of the criteria of this project was to summarize this data by taking the mean of all raw mean and standard deviation measurements, grouped by subject and activity. With 30 subjects and six activities, the result is 180 rows of data.

The remaining 86 of the 88 columns of data in the tidy data set are the mean measurement variables. These variables are numbers representing the means of the selected accelerometer and gyroscope measurements. These variable names were changed to make them more readable. For example, the variable **tBodyAcc-mean()-X** in the raw data set was changed to **tBodyAccelerometerMean-X**. The prefixes 't' for time, and 'f' for frequency were kept as is in the raw data set so that the length of the variable names would not be unduly long.

The names of the 86 measurement variables are:

tBodyAccelerometerMean.X  
tBodyAccelerometerMean.Y  
tBodyAccelerometerMean.Z  
tBodyAccelerometerSTD.X  
tBodyAccelerometerSTD.Y  
tBodyAccelerometerSTD.Z  
tGravityAccelerometerMean.X  
tGravityAccelerometerMean.Y  
tGravityAccelerometerMean.Z  
tGravityAccelerometerSTD.X  
tGravityAccelerometerSTD.Y  
tGravityAccelerometerSTD.Z  
tBodyAccelerometerJerkMean.X  
tBodyAccelerometerJerkMean.Y  
tBodyAccelerometerJerkMean.Z  
tBodyAccelerometerJerkSTD.X  
tBodyAccelerometerJerkSTD.Y  
tBodyAccelerometerJerkSTD.Z  
tBodyGyroscopeMean.X  
tBodyGyroscopeMean.Y  
tBodyGyroscopeMean.Z  
tBodyGyroscopeSTD.X  
tBodyGyroscopeSTD.Y  
tBodyGyroscopeSTD.Z  
tBodyGyroscopeJerkMean.X  
tBodyGyroscopeJerkMean.Y  
tBodyGyroscopeJerkMean.Z  
tBodyGyroscopeJerkSTD.X  
tBodyGyroscopeJerkSTD.Y  
tBodyGyroscopeJerkSTD.Z  
tBodyAccelerometerMagnitudeMean  
tBodyAccelerometerMagnitudeSTD  
tGravityAccelerometerMagnitudeMean  
tGravityAccelerometerMagnitudeSTD  
tBodyAccelerometerJerkMagnitudeMean  
tBodyAccelerometerJerkMagnitudeSTD  
tBodyGyroscopeMagnitudeMean  
tBodyGyroscopeMagnitudeSTD  
tBodyGyroscopeJerkMagnitudeMean  
tBodyGyroscopeJerkMagnitudeSTD  
fBodyAccelerometerMean.X  
fBodyAccelerometerMean.Y  
fBodyAccelerometerMean.Z  
fBodyAccelerometerSTD.X  
fBodyAccelerometerSTD.Y  
fBodyAccelerometerSTD.Z  
fBodyAccelerometerMeanFrequency.X  
fBodyAccelerometerMeanFrequency.Y  
fBodyAccelerometerMeanFrequency.Z  
fBodyAccelerometerJerkMean.X  
fBodyAccelerometerJerkMean.Y  
fBodyAccelerometerJerkMean.Z  
fBodyAccelerometerJerkSTD.X  
fBodyAccelerometerJerkSTD.Y  
fBodyAccelerometerJerkSTD.Z  
fBodyAccelerometerJerkMeanFrequency.X  
fBodyAccelerometerJerkMeanFrequency.Y  
fBodyAccelerometerJerkMeanFrequency.Z  
fBodyGyroscopeMean.X  
fBodyGyroscopeMean.Y  
fBodyGyroscopeMean.Z  
fBodyGyroscopeSTD.X  
fBodyGyroscopeSTD.Y  
fBodyGyroscopeSTD.Z  
fBodyGyroscopeMeanFrequency.X  
fBodyGyroscopeMeanFrequency.Y  
fBodyGyroscopeMeanFrequency.Z  
fBodyAccelerometerMagnitudeMean  
fBodyAccelerometerMagnitudeSTD  
fBodyAccelerometerMagnitudeMeanFrequency  
fBodyAccelerometerJerkMagnitudeMean  
fBodyAccelerometerJerkMagnitudeSTD  
fBodyAccelerometerJerkMagnitudeMeanFrequency  
fBodyGyroscopeMagnitudeMean  
fBodyGyroscopeMagnitudeSTD  
fBodyGyroscopeMagnitudeMeanFrequency  
fBodyGyroscopeJerkMagnitudeMean  
fBodyGyroscopeJerkMagnitudeSTD  
fBodyGyroscopeJerkMagnitudeMeanFrequency  
angle.tBodyAccelerometerMean.gravity  
angle.tBodyAccelerometerJerkMean.gravityMean  
angle.tBodyGyroscopeMean.gravityMean  
angle.tBodyGyroscopeJerkMean.gravityMean  
angle.X.gravityMean  
angle.Y.gravityMean  
angle.Z.gravityMean  
