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
2. Change the variable names so that special characters "()-," are not present. replace them with "_" where necessary to preserve readability. This is done so that when the final output, summary.txt, is read back into R, the column names are not changed bu make.names to make them syntactically valid.
3. The information about the test subject index and the activity was in separate files. This was prepended to the observations. Activity labels were used instead of activity index to make it descriptive.
4. The test data was appended to the training data (totalData data frame in the program).
5. The resulting data was sorted by activity and then by participantNumber (test subject number). This is not strictly necessary but makes the data easier to look at.
6. The data was melted by using activity and participantNumber as ids and the rest as measurements.
7. The melted data was casted by activity and participant-wise while applying the mean operation.
8. The resulting data (summaryData data frame in the program) was written out to file "summary.txt" after enclosing the column names in mean(). It is felt that the original column names were logically defined, descriptive and did not need to be renamed further.

In order to re-read "summary.txt" please use header=TRUE option in the read.table() command.

The next section contains the codebook describing details of the 88 columns.


# Codebook
This section lists the variables that represent the columns of the summary dataset.

## Description
There are 88 variables.
The "activity" variable is a mnemonic that denotes what the user activity that is being summarized in this row. This can be viewed as the "main label" of the study. 
The "participantNumber" variable denotes which of the 30 study participants is summarized in this row. This can be viewed as an auxiliary variable of the study.

The remaining variables are the primary observations or measurements of the study. Their meaning can be derived from the rigid yet explanatory naming convention adopted in naming the variables.

1. The initial prefix "mean_" indicates that the observations are mean values of the particular quantity for the given "activity" and "participantNumber". This is only transformative operation on the raw variables performed in the script. All other operations are filtering operations.
2. If the next prefix starts with "t" it is a time domain measurement.
3. If the next prefix starts with "f" it is based on Fast Fourier Transform (FFT) of the time domain measurement.
4. If the next sufix is of the form angle_"a"_"b", it is the angle between vectors "a" and "b". Vector "a" may denote the cardinal X, Y or Z directions. Derivation of angle is further described in feature_info.txt of the original data set and is present in the original raw data.
5. If the next prefix is "Body" it denotes the high frequency component of the quantity under consideration.
6. If the next prefix is "Gravity" it denotes the low frequency or constant component of the quantity under consideration.
7. If the next prefix is "Acc", the measurement was performed by the accelerometer.
8. If the next prefix is "Gyro", the measurement was performed by the  gyroscope.
9. If the next prefix is "Jerk", it denotes the derived "Jerk" quantity as described in the original feature_info.txt
10. If prefix "_mean" is present in the name, it indicates that the quantity is the arithmetic mean of the measurement denoted by the rest of name. This operation is performed in the raw data. 
11. If prefix "_meanFreq" is present in the name, it indicates that the quantity is the wighted mean of the FFT components of the measurement denoted by the rest of name. This operation is performed in the raw data. 
12. If prefix "_std" is present in the name, it indicates that the quantity is the standard deviation of the measurement denoted by the rest of name. This operation is performed in the raw data. 
13. If suffix "Mean" is present, it represents a mean over an observation interval as opposed to mean across observations.
14. If one of the suffixes "-X', "-Y" or "-Z" is present, it denotes which of the cardinal directions the measurement applies to.

As an example "mean_tGravityAcc_mean_Z" follows cases 1, 2, 6, 7, 10, and 14 above. It is the arithmetic mean of observations for a particular activity and participant of mean time domain low frequency (Gravity) measurements in the vertical (Z) direction. 

- Exception: The word "gravity" in mean_angle_tBodyAccMean_gravity does not appear to follow these rules, it is most likely to be "gravityMean" which would make it consistent with the other angle variables. This name existed in raw data and is not changed due to lack of information, but noted here to flag the only naming inconsistency.

## Units, variable types and ranges.

1. The "activity" variable is a unit-less string and must be one of: {WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING}
2. The "participantNumber" variable is a unit-less integer and must be between 1 and 30 inclusive.
3. All "_mean", "_meanFreq" and "Mean" variables are unit-less real numbers since they are normalized. Normalization has constrained them to range -1 and 1 inclusive. 
4. All "_std" variables are unit-less real numbers since they represent standard deviation of normalized quantities. Since the numbers are between -1 and 1, the "_std" deviation is also constrained to that range.

## List of variables
The following is the list of variable names in the summary data. Their meaning can be inferred by the rules above and their units and ranges are as stated above as well.

activity
participantNumber
mean_tBodyAcc_mean_X
mean_tBodyAcc_mean_Y
mean_tBodyAcc_mean_Z
mean_tBodyAcc_std_X
mean_tBodyAcc_std_Y
mean_tBodyAcc_std_Z
mean_tGravityAcc_mean_X
mean_tGravityAcc_mean_Y
mean_tGravityAcc_mean_Z
mean_tGravityAcc_std_X
mean_tGravityAcc_std_Y
mean_tGravityAcc_std_Z
mean_tBodyAccJerk_mean_X
mean_tBodyAccJerk_mean_Y
mean_tBodyAccJerk_mean_Z
mean_tBodyAccJerk_std_X
mean_tBodyAccJerk_std_Y
mean_tBodyAccJerk_std_Z
mean_tBodyGyro_mean_X
mean_tBodyGyro_mean_Y
mean_tBodyGyro_mean_Z
mean_tBodyGyro_std_X
mean_tBodyGyro_std_Y
mean_tBodyGyro_std_Z
mean_tBodyGyroJerk_mean_X
mean_tBodyGyroJerk_mean_Y
mean_tBodyGyroJerk_mean_Z
mean_tBodyGyroJerk_std_X
mean_tBodyGyroJerk_std_Y
mean_tBodyGyroJerk_std_Z
mean_tBodyAccMag_mean
mean_tBodyAccMag_std
mean_tGravityAccMag_mean
mean_tGravityAccMag_std
mean_tBodyAccJerkMag_mean
mean_tBodyAccJerkMag_std
mean_tBodyGyroMag_mean
mean_tBodyGyroMag_std
mean_tBodyGyroJerkMag_mean
mean_tBodyGyroJerkMag_std
mean_fBodyAcc_mean_X
mean_fBodyAcc_mean_Y
mean_fBodyAcc_mean_Z
mean_fBodyAcc_std_X
mean_fBodyAcc_std_Y
mean_fBodyAcc_std_Z
mean_fBodyAcc_meanFreq_X
mean_fBodyAcc_meanFreq_Y
mean_fBodyAcc_meanFreq_Z
mean_fBodyAccJerk_mean_X
mean_fBodyAccJerk_mean_Y
mean_fBodyAccJerk_mean_Z
mean_fBodyAccJerk_std_X
mean_fBodyAccJerk_std_Y
mean_fBodyAccJerk_std_Z
mean_fBodyAccJerk_meanFreq_X
mean_fBodyAccJerk_meanFreq_Y
mean_fBodyAccJerk_meanFreq_Z
mean_fBodyGyro_mean_X
mean_fBodyGyro_mean_Y
mean_fBodyGyro_mean_Z
mean_fBodyGyro_std_X
mean_fBodyGyro_std_Y
mean_fBodyGyro_std_Z
mean_fBodyGyro_meanFreq_X
mean_fBodyGyro_meanFreq_Y
mean_fBodyGyro_meanFreq_Z
mean_fBodyAccMag_mean
mean_fBodyAccMag_std
mean_fBodyAccMag_meanFreq
mean_fBodyBodyAccJerkMag_mean
mean_fBodyBodyAccJerkMag_std
mean_fBodyBodyAccJerkMag_meanFreq
mean_fBodyBodyGyroMag_mean
mean_fBodyBodyGyroMag_std
mean_fBodyBodyGyroMag_meanFreq
mean_fBodyBodyGyroJerkMag_mean
mean_fBodyBodyGyroJerkMag_std
mean_fBodyBodyGyroJerkMag_meanFreq
mean_angle_tBodyAccMean_gravity
mean_angle_tBodyAccJerkMean_gravityMean
mean_angle_tBodyGyroMean_gravityMean
mean_angle_tBodyGyroJerkMean_gravityMean
mean_angle_X_gravityMean
mean_angle_Y_gravityMean
mean_angle_Z_gravityMean
