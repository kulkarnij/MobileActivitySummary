# Study Design
## Background
This study summarizes the data collected during the following project
> Human Activity Recognition Using Smartphones Dataset
> Version 1.0
> ===================================================================================================
> Jorge L. Reyes-Ortiz(1,2), Davide Anguita(1), Alessandro Ghio(1), Luca Oneto(1) and Xavier Parra(2)
> 1 - Smartlab - Non-Linear Complex Systems Laboratory
> DITEN - Universit�  degli Studi di Genova, Genoa (I-16145), Italy. 
> 2 - CETpD - Technical Research Centre for Dependency Care and Autonomous Living
> Universitat Polit�cnica de Catalunya (BarcelonaTech). Vilanova i la Geltr� (08800), Spain
> activityrecognition '@' smartlab.ws 

This data is available at the following website and is henceforth called the original data or the raw data:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

This project measured acceleration during accelerometer and gyroscope in a smart phone while test subjects were engaged in one of the six activities:
{WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING}
There were 30 test subjects. Out of these measurements the study derived additional frequency domain and angular movement features as described in the feature_info.txt file. This project summarizes this data.

This summarization study was conducted as a the course project for the Coursea course "Getting and Cleaning Data" by <name withheld>.
This file is the codebook for that project. Please refer to the README.me file for other description of other components.

## Summarization Procedure

The summarization procedure attempts to answer the following question: For every variable measured, consider the mean and standard deviation (discard min, max, kurtosis etc.) and for these mean and standard deviations, what is the average over all observations made while a particular user is engaged in a particular activity? The original observations were split into training (70%) and test (30%) sets and we were asked to combine these.

The summarization script "run_analysis.R" performs the following steps. These steps are slightly reordered from the coursera description so that we discard unwanted data as soon as possible which means  we deal with as small a frame as possible.

1. Select the mean and standard deviation values from training and test datasets. Apart from the variables that were averaged across observations, variables that were averaged across time were also included. These were included because they are averaged and more importantly they are the only way to capture the angle information in the raw data, which could be important for any machine learning algorithm. This is a filtering step. It selects 86 variables.
2. The information about the test subject index and the activity was in separate files. This was prepended to the observations. Activity labels were used instead of activity index to make it descriptive.
3. The test data was appended to the training data (totalData data frame in the program).
4. The resulting data was sorted by activity and then by participantNumber (test subject number). This is not strictly necessary but makes the data easier to look at.
5. The data was melted by using activity and participantNumber as ids and the rest as measurements.
6. The melted data was casted by activity and participant-wise while applying the mean operation.
7. The resulting data (summaryData data frame in the program) was written out to file "summary.txt" after enclosing the column names in mean(). It is felt that the original column names were logically defined, descriptive and did not need to be renamed further.

In order to re-read "summary.txt" please use header=TRUE option in the read.table() command.

The next section contains the codebook describing details of the 88 columns.


# Codebook
This section lists the variables that represent the columns of the summary dataset.

## Description
There are 88 variables.
The "activity" variable is a mnemonic that denotes what the user activity that is being summarized in this row. This can be viewed as the "main label" of the study. 
The "participantNumber" variable denotes which of the 30 study participants is summarized in this row. This can be viewed as an auxiliary variable of the study.

The remaining variables are the primary observations or measurements of the study. Their meaning can be derived from the rigid yet explanatory naming convention adopted in naming the variables.

1. The enclosing mean() indicates that the observations are mean values of the particular quantity for the given "activity" and "participantNumber". This is only transformative operation on the raw variables performed in the script. All other operations are filtering operations.
2. If the next prefix starts with "t" it is a time domain measurement.
3. If the next prefix starts with "f" it is based on Fast Fourier Transform (FFT) of the time domain measurement.
4. If the next prefix starts with angle("a","b") it is the angle between vectors "a" and "b". Vector "a" may denote the cardinal X, Y or Z directions. Derivation of angle() is further described in feature_info.txt of the original data set and is present in the original raw data.
5. If the next prefix is "Body" it denotes the high frequency component of the quantity under consideration.
6. If the next prefix is "Gravity" it denotes the low frequency or constant component of the quantity under consideration.
7. If the next prefix is "Acc", the measurement was performed by the accelerometer.
8. If the next prefix is "Gyro", the measurement was performed by the  gyroscope.
9. If the next prefix is Jerk, it denotes the derived "Jerk" quantity as described in the original feature_info.txt
10. If prefix -mean() is present in the name, it indicates that the quantity is the arithmetic mean of the measurement denoted by the rest of name. This operation is performed in the raw data. 
11. If prefix -meanFreq() is present in the name, it indicates that the quantity is the wighted mean of the FFT components of the measurement denoted by the rest of name. This operation is performed in the raw data. 
12. If prefix -std() is present in the name, it indicates that the quantity is the standard deviation of the measurement denoted by the rest of name. This operation is performed in the raw data. 
13. If suffix Mean is present, it represents a mean over an observation interval as opposed to mean across observations.
14. If one of the suffixes "-X', "-Y" or "-Z" is present, it denotes which of the cardinal directions the measurement applies to.

As an example "mean(tGravityAcc-mean()-Z)" follows cases 1, 2, 6, 7, 10, and 14 above. It is the arithmetic mean of observations for a particular activity and participant of mean time domain low frequency (Gravity) measurements in the vertical (Z) direction. 

- Exception: The word "gravity" in mean(angle(tBodyAccMean,gravity)) does not appear to follow these rules, it is most likely to be "gravityMean" which would make it consistent with the other angle variables. This name existed in raw data and is not changed due to lack of information, but noted here to flag the only naming inconsistency.

## Units, variable types and ranges.

1. The "activity" variable is a unit-less string and must be one of: {WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING}
2. The "participantNumber" variable is a unit-less integer and must be between 1 and 30 inclusive.
3. All "-mean()", "-meanFreq()" and "Mean" variables are unit-less real numbers since they are normalized. Normalization has constrained them to range -1 and 1 inclusive. 
4. All "-std()" variables are unit-less real numbers since they represent standard deviation of normalized quantities. Since the numbers are between -1 and 1, the "-std()" deviation is also constrained to that range.

## List of variables
The following is the list of variable names in the summary data. The "- " at the beginning is just the md markdown for a list and is not a part of the variable name.

- activity    
- participantNumber
- mean(tBodyAcc-mean()-X)
- mean(tBodyAcc-mean()-Y)
- mean(tBodyAcc-mean()-Z)
- mean(tBodyAcc-std()-X)
- mean(tBodyAcc-std()-Y)
- mean(tBodyAcc-std()-Z)
- mean(tGravityAcc-mean()-X)
- mean(tGravityAcc-mean()-Y)
- mean(tGravityAcc-mean()-Z)
- mean(tGravityAcc-std()-X)
- mean(tGravityAcc-std()-Y)
- mean(tGravityAcc-std()-Z)
- mean(tBodyAccJerk-mean()-X)
- mean(tBodyAccJerk-mean()-Y)
- mean(tBodyAccJerk-mean()-Z)
- mean(tBodyAccJerk-std()-X)
- mean(tBodyAccJerk-std()-Y)
- mean(tBodyAccJerk-std()-Z)
- mean(tBodyGyro-mean()-X)
- mean(tBodyGyro-mean()-Y)
- mean(tBodyGyro-mean()-Z)
- mean(tBodyGyro-std()-X)
- mean(tBodyGyro-std()-Y)
- mean(tBodyGyro-std()-Z)
- mean(tBodyGyroJerk-mean()-X)
- mean(tBodyGyroJerk-mean()-Y)
- mean(tBodyGyroJerk-mean()-Z)
- mean(tBodyGyroJerk-std()-X)
- mean(tBodyGyroJerk-std()-Y)
- mean(tBodyGyroJerk-std()-Z)
- mean(tBodyAccMag-mean())
- mean(tBodyAccMag-std())
- mean(tGravityAccMag-mean())
- mean(tGravityAccMag-std())
- mean(tBodyAccJerkMag-mean())
- mean(tBodyAccJerkMag-std())
- mean(tBodyGyroMag-mean())
- mean(tBodyGyroMag-std())
- mean(tBodyGyroJerkMag-mean())
- mean(tBodyGyroJerkMag-std())
- mean(fBodyAcc-mean()-X)
- mean(fBodyAcc-mean()-Y)
- mean(fBodyAcc-mean()-Z)
- mean(fBodyAcc-std()-X)
- mean(fBodyAcc-std()-Y)
- mean(fBodyAcc-std()-Z)
- mean(fBodyAcc-meanFreq()-X)
- mean(fBodyAcc-meanFreq()-Y)
- mean(fBodyAcc-meanFreq()-Z)
- mean(fBodyAccJerk-mean()-X)
- mean(fBodyAccJerk-mean()-Y)
- mean(fBodyAccJerk-mean()-Z)
- mean(fBodyAccJerk-std()-X)
- mean(fBodyAccJerk-std()-Y)
- mean(fBodyAccJerk-std()-Z)
- mean(fBodyAccJerk-meanFreq()-X)
- mean(fBodyAccJerk-meanFreq()-Y)
- mean(fBodyAccJerk-meanFreq()-Z)
- mean(fBodyGyro-mean()-X)
- mean(fBodyGyro-mean()-Y)
- mean(fBodyGyro-mean()-Z)
- mean(fBodyGyro-std()-X)
- mean(fBodyGyro-std()-Y)
- mean(fBodyGyro-std()-Z)
- mean(fBodyGyro-meanFreq()-X)
- mean(fBodyGyro-meanFreq()-Y)
- mean(fBodyGyro-meanFreq()-Z)
- mean(fBodyAccMag-mean())
- mean(fBodyAccMag-std())
- mean(fBodyAccMag-meanFreq())
- mean(fBodyBodyAccJerkMag-mean())
- mean(fBodyBodyAccJerkMag-std())
- mean(fBodyBodyAccJerkMag-meanFreq())
- mean(fBodyBodyGyroMag-mean())
- mean(fBodyBodyGyroMag-std())
- mean(fBodyBodyGyroMag-meanFreq())
- mean(fBodyBodyGyroJerkMag-mean())
- mean(fBodyBodyGyroJerkMag-std())
- mean(fBodyBodyGyroJerkMag-meanFreq())
- mean(angle(tBodyAccMean,gravity))
- mean(angle(tBodyAccJerkMean),gravityMean))
- mean(angle(tBodyGyroMean,gravityMean))
- mean(angle(tBodyGyroJerkMean,gravityMean))
- mean(angle(X,gravityMean))
- mean(angle(Y,gravityMean))
- mean(angle(Z,gravityMean))
