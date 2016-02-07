#Download file and get data
Url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(Url,destfile="./Dataset.zip")
unzip(zipfile="./Dataset.zip",exdir=".")
path <- file.path("." , "UCI HAR Dataset")
files<-list.files(path, recursive=TRUE)
dATest  <- read.table(file.path(path, "test" , "Y_test.txt" ),header = FALSE)
dATrain <- read.table(file.path(path, "train", "Y_train.txt"),header = FALSE)
dSTrain <- read.table(file.path(path, "train", "subject_train.txt"),header = FALSE)
dSTest  <- read.table(file.path(path, "test" , "subject_test.txt"),header = FALSE)
dFTest  <- read.table(file.path(path, "test" , "X_test.txt" ),header = FALSE)
dFTrain <- read.table(file.path(path, "train", "X_train.txt"),header = FALSE)

# Merges the training and the test sets to create one data set.
dS<- rbind(dSTrain, dSTest)
dA<- rbind(dATrain, dATest)
dF<- rbind(dFTrain, dFTest)

#Extracts only the measurements on the mean and standard deviation for each measurement
names(dS) <- c("subject")
names(dA) <- c("activity")
dFNames <- read.table(file.path(path, "features.txt"),head=FALSE)
names(dF)<- dFNames$V2
dC <- cbind(dS, dA)
Data <- cbind(dF, dC)
subdFNames<-dFNames$V2[grep("mean\\(\\)|std\\(\\)", dFNames$V2)]
selectedNames<-c(as.character(subdFNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)
activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "ragsdata.txt",row.name=FALSE)