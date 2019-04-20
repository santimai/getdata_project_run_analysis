library(readr)
library(dplyr)

#Preparation Stage

getwd()
setwd("C:/Users/CPUser/Desktop/Data analytics/The data Scientist's Toolbox/getdata_project_run_analysis/UCI HAR Dataset")

dffeatures <- read.table("features.txt", col.names = c("n","functions"))
dfactivities <- read.table("activity_labels.txt",col.names = c("code","activity"))

setwd("C:/Users/CPUser/Desktop/Data analytics/The data Scientist's Toolbox/getdata_project_run_analysis/UCI HAR Dataset/train")

dfsubject_train <- read.table("subject_train.txt", col.names = "subject")
dfX_train <- read.table("X_train.txt", col.names = dffeatures$functions)
dfY_train <- read.table("Y_train.txt", col.names = "code")


setwd("C:/Users/CPUser/Desktop/Data analytics/The data Scientist's Toolbox/getdata_project_run_analysis/UCI HAR Dataset/test")

dfsubject_test <- read.table("subject_test.txt", col.names = "subject")
dfX_test <- read.table("X_test.txt", col.names = dffeatures$functions)
dfY_test <- read.table("Y_test.txt", col.names = "code")

#1. Merges the training and the test sets to create one data set.

dftrain <- cbind(dfsubject_train,dfX_train,dfY_train)
dftest <- cbind(dfsubject_test,dfX_test,dfY_test)
dfMerges <- rbind(dftrain,dftest)


##2.Extracts only the measurements on the mean and standard deviation for each measurement.

dfmean_std <- dfMerges  %>% select(subject, code, contains("mean"), contains("std"))

## 3.Uses descriptive activity names to name the activities in the data set

dfmean_std$code <- dfactivities[dfmean_std$code, 2]

## 4.Appropriately labels the data set with descriptive variable names.
names(dfmean_std)  
names(dfmean_std)[2]="activity"
names(dfmean_std) <- gsub("^t","time",names(dfmean_std))
names(dfmean_std) <- gsub("Acc","Accelerometer",names(dfmean_std))
names(dfmean_std) <- gsub("^f","frequency",names(dfmean_std))
names(dfmean_std) <- gsub("BodyBody","Body",names(dfmean_std))
names(dfmean_std) <- gsub("tBody","timeBody",names(dfmean_std))

##5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


dfdata_set <- dfmean_std %>% group_by(activity,subject) %>% summarise_all(funs(mean))

dfdata_set
write.table(dfdata_set,file = "data_set.txt",row.name=FALSE)
getwd()
