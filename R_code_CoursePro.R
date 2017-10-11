## Download and unzip the dataset:

library(reshape2)
filename <- "getdata_dataset.zip"

if (!file.exists(filename)){
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
    download.file(fileURL, filename, method="curl")
}  

if (!file.exists("UCI HAR Dataset")) { 
    unzip(filename) 
}

# Load activity labels and features:

ActiLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
ActiLabels[,2] <- as.character(ActiLabels[,2])
Features <- read.table("UCI HAR Dataset/features.txt")
Features[,2] <- as.character(Features[,2])

# Extract only the data on mean and standard deviation

FeatNeeded <- grep(".*mean.*|.*std.*", Features[,2])
FeatNeeded.names <- Features[FeatNeeded,2]
FeatNeeded.names = gsub('-mean', 'Mean', FeatNeeded.names)
FeatNeeded.names = gsub('-std', 'Std', FeatNeeded.names)
FeatNeeded.names <- gsub('[-()]', '', FeatNeeded.names)

# Load the datasets

Train_test <- read.table("UCI HAR Dataset/train/X_train.txt")[FeatNeeded]
TrainAct <- read.table("UCI HAR Dataset/train/Y_train.txt")
TrainSubj <- read.table("UCI HAR Dataset/train/subject_train.txt")
Train <- cbind(TrainSubj, TrainAct, Train_test)

Test_set <- read.table("UCI HAR Dataset/test/X_test.txt")[FeatNeeded]
TestAct <- read.table("UCI HAR Dataset/test/Y_test.txt")
TestSubj <- read.table("UCI HAR Dataset/test/subject_test.txt")
Test <- cbind(TestSubj, TestAct, Test_set)

# merge datasets and add labels

Complete_Data <- rbind(Train, Test)
colnames(Complete_Data) <- c("Subject", "Activity", FeatNeeded.names)

# turn activities & subjects into factors

Complete_Data$Activity <- factor(Complete_Data$Activity, levels = ActiLabels[,1], labels = ActiLabels[,2])
Complete_Data$Subject <- as.factor(Complete_Data$Subject)

Complete_Data.melted <- melt(Complete_Data, id = c("Subject", "Activity"))
Complete_Data.mean <- dcast(Complete_Data.melted, Subject + Activity ~ variable, mean)

write.table(Complete_Data.mean, "TTiidy.txt", row.names = FALSE, quote = FALSE)






