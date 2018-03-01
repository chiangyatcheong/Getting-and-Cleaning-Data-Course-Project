# Q1. Merges the training and the test sets to create one data set.

library(data.table) # Use data table

x_train <- fread("./train/X_train.txt")

x_test <- fread("./test/X_test.txt")

x_full <- rbind(x_train, x_test)

y_train <- fread("./train/y_train.txt")

y_test <- fread("./test/y_test.txt")

y_full <- rbind(y_train, y_test)

rm(x_train,x_test,y_train,y_test) # only keeping the full datasets


# Q2. Extracts only the measurements on the mean and standard deviation for each measurement.


features_title <- fread("features.txt")[,2]

colnames(x_full) <- features_title[[1]]

x_selected <- subset(x_full,select = grep('-(mean|std)\\(',features_title[[1]]))


# Q3. Uses descriptive activity names to name the activities in the data set 


activity_labels <- fread("activity_labels.txt")[[2]] # there are 6 observations (i.e. column names)

Activity <- activity_labels[y_full[[1]]]    # apply the labels to the corresponding activity

data <- cbind(Activity,x_selected)


# Q4. Appropriately labels the data set with descriptive variable names.


colnames(data) <- gsub("mean", "Mean", colnames(data))
colnames(data) <- gsub("std", "Std", colnames(data))
colnames(data) <- gsub("^t", "Time", colnames(data))
colnames(data) <- gsub("^f", "Frequency", colnames(data))
colnames(data) <- gsub("\\(\\)", "", colnames(data))
colnames(data) <- gsub("-", "", colnames(data))
colnames(data) <- gsub("BodyBody", "Body", colnames(data))


# Q5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject


subject_train <- fread("./train/subject_train.txt")
subject_test <- fread("./test/subject_test.txt")
Subject <- rbind(subject_train,subject_test)[[1]]
data_set <- cbind(Subject,data)

library(dplyr) # Use the package dplyr to summarise the data by subject and activity

average_data_set <- data_set %>%
    group_by(Subject,Activity) %>%
    summarise_all(funs(mean))

write.table(average_data_set,row.name = FALSE,file = "Clean_data.txt")    

