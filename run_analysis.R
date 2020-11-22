##Merges the training and the test sets to create one data set
## 1.Concatenate the data tables by rows
dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity<- rbind(dataActivityTrain, dataActivityTest)
dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)


## 2.set names to variables

names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
dataFeaturesNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2

## 3.Merge columns to get the data frame Data for all data

dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)


## Extracts only the measurements on the mean and standard deviation for each measurement

## 1. Subset Name of Features by measurements on the mean and standard deviation
## i.e taken Names of Features with “mean()” or “std()”

subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]
  
## 2. Subset the data frame Data by selected names of Features

selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)

## 3. Check the structures of the data frame Data

str(Data)


## Uses descriptive activity names to name the activities in the data set
## 1.Read descriptive activity names from “activity_labels.txt”


activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)

## 2facorize Variale activity in the data frame Data using descriptive activity names

## 3. check

head(Data$activity,30)

##  Appropriately labels the data set with descriptive variable names
## In the former part, variables activity and subject and names of the activities have been labelled using descriptive names.In this part, Names of Feteatures will labelled using descriptive variable names.

### prefix t is replaced by time
### Acc is replaced by Accelerometer
### Gyro is replaced by Gyroscope
### prefix f is replaced by frequency
### Mag is replaced by Magnitude
### BodyBody is replaced by Body

names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

## check

names(Data)

## Creates a second,independent tidy data set and ouput it
##In this part,a second, independent tidy data set will be created with the average of each variable for each activity and each subject based on the data set in step 4.



library(dplyr);
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)


## Prouduce Codebook


library("rmarkdown")
render("codebook.Rmd")




