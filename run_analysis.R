#run_analysis.R Summarizes the UCI mobile data-set. See README.md and Codebook.md for details.

########################## Section 1: Constant Definition  ###################################
#Define all constants here
#Input File Related
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
zipFileName <- "getdata-projectfiles-UCI HAR Dataset.zip"
extractDirName <- "UCI HAR Dataset"
activityLabelsFileName <- "activity_labels.txt"
featureNamesFileName <- "features.txt"
testDataDirName <- "test"
testDataFileName <- "X_test.txt"
testSubjectsFileName <- "subject_test.txt"
testLabelsFileName <- "y_test.txt"
trainDataDirName <- "train"
trainDataFileName <- "X_train.txt"
trainSubjectsFileName <- "subject_train.txt"
trainLabelsFileName <- "y_train.txt"
sep <- .Platform$file.sep


#Processing Related

#Use this for including angles which are averaged over window and can ve viewd as mean quantities.
#This is the default. However the angle quantities to not have std()
meanString <- "mean|Mean"

#Use this to exclude the angle quanitites
#meanString <- "mean"

stdString <- "std"

#Output File Related
outFile <- "summary.txt"


########################## Section 2: Helper Functions   ###################################

# Define helper functions
# In the comments below, <a> means the value of variable "a"
# where "a" is defined at the beginning of the script.

#This function reads a file from the zip archive <zipFileName>
#The zip archive must be located at <extractDirName>
#It takes a variable length list that may consist of 
#variable number of subdirectories in the archive but must end 
#in the name of the file to be read. This list is used to construct
#the file's path.
readData <- function(...) {
  fileToRead <- file.path(extractDirName, ..., fsep=sep)
  dframe <- read.table(unz(zipFile,fileToRead))
  #unlink(zipFile)
  dframe
}

#This functions selects only the mean and std deviation columns from the
#dataframe <dframe> and returns the pruned frame. Columns selected are those
#that match either <meanString> or <stdString>. These strings are defined at the 
#beginning of the script. This function is written to avoid code duplication since
#the same logic runs for test and train data. We choose to prune test and train data
#separately before combining so that we deal with smaller dataframes which may be better 
#in memory constrained systems.
pruneFrame <- function(dframe) {
  colNames <- as.vector(featureName[,2])
  # Do any processing such as lower case, barcket removal etc. here.
  #colNames <- c("activity", "subject",colNames)
  
  #
  colnames(dframe) <- colNames
  selectedColumns = grep(paste(meanString,"|",stdString,sep=""),colNames)
  prunedTestData = dframe[,selectedColumns]
}


#This function appends a column <column> to a frame <dframe> 
# at the beginning at the data frame and names the column <columnName>
#names of the rest of the columns are unchanged.
appendColumn <- function(column, columnName, dframe) {
  names <- colnames(dframe)
  dframe <- cbind(column,dframe)
  names <- c(columnName,names)
  colnames(dframe) <- names
  dframe
}

#This function replaces numeric activity labeles in <dframe> with 
#string equivalents.
#Iterating over index does not work, therefore iterating over labels

stringLabels <- function(dframe){
t1<-dframe
for (label in activityLabels[,2]) {
  index <- activityLabels[activityLabels$V2==label,1]
  #cat("index:",index,"\n")
  #cat("label:",label,"\n")
  t1[t1 == index] <- label
}
t1
}
########################## Section 3: Read Raw Data   ###################################
#Check for zip file, download if needed.
zipFile = file.path(".",zipFileName,fsep=sep)
if(!file.exists(zipFile)) {
  download.file(fileURL,zipFile,method = "curl")
}
if(!file.exists(zipFile)) {
  print("*ERROR: File could not be downloaded, script will continue since no way to exit just the script in R")
  # Other than nested scopes of course.
}

# Read Labels and Features
activityLabels<-readData(activityLabelsFileName)
featureName <- readData(featureNamesFileName)


#Read in test data. Check for consistency
testData <- readData(testDataDirName,testDataFileName)
testSubjects <- readData(testDataDirName,testSubjectsFileName)
testLabels <- readData(testDataDirName,testLabelsFileName)
if((nrow(testData) != nrow(testSubjects)) || (nrow(testData) != nrow(testLabels))) {
  print("*ERROR: Test data samples not consistent with subjects or activity labels. Script will continue since no way to exit just the script in R")
  # Other than nested scopes of course.
}


#Read in training data. Check for consistency
trainData <- readData(trainDataDirName,trainDataFileName)
trainSubjects <- readData(trainDataDirName,trainSubjectsFileName)
trainLabels <- readData(trainDataDirName,trainLabelsFileName)

if((nrow(trainData) != nrow(trainSubjects)) || (nrow(trainData) != nrow(trainLabels))) {
  print("*ERROR: Test data samples not consistent with subjects or activity labels. Script will continue since no way to exit just the script in R")
  # Other than nested scopes of course.
}

#Note: This script performs filtering before merging so as to reduce size of data frames 
#in subsequent processing.

########################## Section 4: Filter Data, add label columns   #############################

#Filter and label test data.
prunedTestData <- pruneFrame(testData)
varNames <- colnames(prunedTestData)
prunedTestData <- appendColumn(testSubjects,"participantNumber",prunedTestData)
stringTestLabels<-stringLabels(testLabels)
prunedTestData <- appendColumn(stringTestLabels,"activity",prunedTestData)

#Filter and label training data.
prunedTrainData <- pruneFrame(trainData)
prunedTrainData <- appendColumn(trainSubjects,"participantNumber",prunedTrainData)
stringTrainLabels<-stringLabels(trainLabels)
prunedTrainData <- appendColumn(stringTrainLabels,"activity",prunedTrainData)


########################## Section 5: Combine and Summarize   #############################
total <- rbind(prunedTrainData,prunedTestData)

#Please note that sorting is optional. It improves readability of "total" and does not
#affect the final results.
attach(total)
total <- total[order(activity,participantNumber),]
detach(total)

library("reshape2")
totalMelt <- melt(total,id=c("activity","participantNumber"),measure.vars=varNames)
sumData <- dcast(totalMelt, activity+participantNumber ~ variable, mean)
sumNames <- colnames(sumData[,-(1:2)])
sumNames<-paste("mean(",sumNames,")",sep="")
colnames(sumData)<-c("activity","participantNumber",sumNames)

write.table(sumData, file = outFile, row.names=FALSE)

#Please use the following command to read  the file back. Notice the header=TRUE option.
#t<-read.table("summary.txt",header=TRUE)
