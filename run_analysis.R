# This script is called "run_analysis.R" that does the following. 
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Part 1: Loading the features file:
features <- read.table("./UCI HAR Dataset/features.txt")[,2]


# Part 2: Extracts only the measurements on the mean and standard deviation
extracted1 <- grep("mean|std", features)
extracted2 <- grep("meanFreq", features)
extractedFeatures <- setdiff(extracted1,extracted2)
features <- features[extractedFeatures]

# Part 3: Loading the activity_labels.txt
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

# Part 4: Loading the Training data sets
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")[,extractedFeatures]
names(X_train) = features
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
names(y_train) = "Activity_Label"
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
names(subject_train) = "Subject"
dataTrain <-cbind(subject_train,X_train,y_train)

# Part 5: Loading the Test data sets
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")[,extractedFeatures]
names(X_test) = features
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
names(y_test) = "Activity_Label"
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt") 
names(subject_test) = "Subject"
dataTest <- cbind(subject_test,X_test,y_test)

# Part 6: Merges the training and the test sets to create one data set.
dataMerge <- rbind(dataTrain,dataTest)

# Part 7: Uses descriptive activity names to name the activities in the data set

dataMerge$Activity_Label <- activity_labels[as.numeric(dataMerge$Activity_Label),2]



# Part 8: Write an independent tidy data set with the average of each variable for each activity and each subject
tidy = aggregate(dataMerge, by=list(subject=dataMerge$Subject, activity = dataMerge$Activity_Label ), mean)
tidy <- tidy[,c(1,2,4:69)]

write.table(tidy, file = "./tidyData.txt",row.name=FALSE )






