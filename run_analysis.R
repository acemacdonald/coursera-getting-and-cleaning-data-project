
# Course 3 Project: Getting and Cleaning Data
#.....................................

install.packages("tidyverse")
library(tidyverse)

# The goal of this project is to present a clean data set.

# Project outline:

# 1. Merges the training and the test sets to create one data set.
# 2 .Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average 
#    of each variable for each activity and each subject.

# Import the relevant datasets

# - 'train/X_train.txt': Training set.

# - 'train/y_train.txt': Training labels.

# - 'test/X_test.txt': Test set.

# - 'test/y_test.txt': Test labels.

filename <- "getdata_dataset.zip"

## Download and unzip the dataset:
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileURL, filename, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}


training_data <- read.table("UCI HAR Dataset/train/X_train.txt")
training_labels <- read.table("UCI HAR Dataset/train/y_train.txt")
training_subjects <- read.table("UCI HAR Dataset/train/subject_train.txt")

test_data <- read.table("UCI HAR Dataset/test/X_test.txt")
test_labels <- read.table("UCI HAR Dataset/test/y_test.txt")
test_subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")

activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
activity_labels[,2] <- as.character(activity_labels[,2])

test_labels <- bind_cols(test_subjects, test_labels)
training_labels <- bind_cols(training_subjects, training_labels)

total_labels <- rbind(test_labels, training_labels)

# Each dataset has the same amount of columns. We want to add the labels together.

total_data <- bind_rows(test_data, training_data)

data <- bind_cols(total_labels, total_data)

features <- read.table("C:/Users/AngusMacDonald/Documents/Online Studying/Data Science Specialization/Course 3/Project/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)
features[,2] <- as.character(features[,2])
# Define columns names

colnames(data) <- c("Subject", "Activity", features[, 2])

# Now we have the dataset and the columns names, we need to extract only the measurements
# on the standard deviation and the mean.

# Because the frequency is not a mean element but rather the frequency of the mean,
# I have left out columns such as meanFreq.

data_mean <- data[, grep("mean()", names(data), value = TRUE, fixed = TRUE)]
data_std <-  data[, grep("std()", names(data), value = TRUE, fixed = TRUE)]

data_final <- bind_cols(data_mean, data_std)
data_F <- bind_cols(total_labels, data_final)

colnames(data_F)[1:2] <- c('Subject', 'Activity')

# Now that we have the final dataset we can create our "tidy" dataset
# This dataset must have 6 activities for each observation in the dataset.

data_F$Activity <- factor(data_F$Activity, levels = activity_labels[,1], labels = activity_labels[,2])
data_F$Subject <- as.factor(data_F$Subject)

data.melted <- melt(data_F, id = c("Subject", "Activity"))
data.mean <- dcast(data.melted, Subject + Activity ~ variable, mean)

write.table(data.mean, "tidy.txt", row.names = FALSE, quote = FALSE)





