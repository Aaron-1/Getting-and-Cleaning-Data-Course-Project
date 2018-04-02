
## file is donwloaded into working directory
## unzip file

unzip(zipfile="./getdata_projectfiles_UCI HAR Dataset.zip",exdir="./Data")


## Load required libraries
library(data.table)
library (plyr)

## read test set
XTest<- read.table("./Data/UCI HAR Dataset/test/X_test.txt", header = FALSE)
YTest<- read.table("./Data/UCI HAR Dataset/test/Y_test.txt", header = FALSE)
SubjectTest <-read.table("./Data/UCI HAR Dataset/test/subject_test.txt", header = FALSE)


## read train set

XTrain<- read.table("./Data/UCI HAR Dataset/train/X_train.txt", header = FALSE)
YTrain<- read.table("./Data/UCI HAR Dataset/train/Y_train.txt", header = FALSE)
SubjectTrain <-read.table("./Data/UCI HAR Dataset/train/subject_train.txt", header = FALSE)

## read features & activity

Features<-read.table("./Data/UCI HAR Dataset/features.txt")
Activity<-read.table("./Data/UCI HAR Dataset/activity_labels.txt")


##combining data sets

XData<-rbind(XTrain, XTest)
YData<-rbind(YTrain, YTest)
setnames (YData,"V1", "Activity")
Subject<-rbind(SubjectTrain,SubjectTest)
setnames (Subject, "V1", "Subject")

## get columns that have mean or std in name

columns<-grep("mean\\(\\)|std\\(\\)", Features[,2])

## getting only variables with mean / std

XData.Subset <- XData[,columns]

##Uses descriptive activity names to name the activities in the data set

YData[, 1] <- Activity[YData[, 1], 2]


## get names for all vairables

 names<-Features[columns,2] 

## update Xdata Set with column names

names(XData.Subset) <- names

##merge data

CleanedData<-cbind(Subject,YData,XData.Subset)

## create Tidy data set with  average of each variable for each activity and each subject.

CleanedData<-data.table(CleanedData)
TidyData <- CleanedData[, lapply(.SD, mean), by = 'Subject,Activity']

