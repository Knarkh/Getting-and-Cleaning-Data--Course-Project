## run_analysis.R
# This R script run_analysis.R does the following:
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each
# measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set
# with the average of each variable for each activity and each subject


# -----------------------------------------------------------------------------
# 1. Merges the training and the test sets to create one data set.
# -----------------------------------------------------------------------------

library(plyr)
library(tidyr)
library(dplyr)
library(data.table)

## set file names for training, test and variable names
#  Training
fileName_Training_set <- "./course_project_gcd/UCI HAR Dataset/train/X_train.txt"
fileName_Training_activity <- "./course_project_gcd/UCI HAR Dataset/train/y_train.txt"
fileName_Training_subjects <- "./course_project_gcd/UCI HAR Dataset/train/subject_train.txt"

#  Test
fileName_Test_set <- "./course_project_gcd/UCI HAR Dataset/test/X_test.txt"
fileName_Test_activity <- "./course_project_gcd/UCI HAR Dataset/test/y_test.txt"
fileName_Test_subjects <- "./course_project_gcd/UCI HAR Dataset/test/subject_test.txt"

#  Variables
fileName_features <- "./course_project_gcd/UCI HAR Dataset/features.txt"

## read files into dataframes
#  Training
Training_set <- read.table(file = fileName_Training_set)
Training_activity <- read.table(file = fileName_Training_activity)
Training_subjects <- read.table(file = fileName_Training_subjects)

#  Test
Test_set <- read.table(file = fileName_Test_set)
Test_activity <- read.table(file = fileName_Test_activity)
Test_subjects <- read.table(file = fileName_Test_subjects)

#  features
features <- read.table(file = fileName_features)

# Activity Labels
activity_labels <- as.data.frame(read.table("./course_project_gcd/UCI HAR Dataset/activity_labels.txt"))
names(activity_labels)[1] <- "Activity_Number"
names(activity_labels)[2] <- "Activity_Label"

## merge training data
training_df <- cbind(Training_subjects, Training_activity, Training_set)

## merge test data
test_df <- cbind(Test_subjects, Test_activity, Test_set)

## create a header using variables dataframe
header <- as.character(features[,2])

names(training_df)[3:563] <- header
names(test_df)[3:563] <- header

names(training_df)[1] <- "Subjects"
names(training_df)[2] <- "Activity"

names(test_df)[1] <- "Subjects"
names(test_df)[2] <- "Activity"

## merge training and test data
test_and_training <- bind_rows(training_df, test_df)

# -----------------------------------------------------------------------------
# 2. Extracts only the measurements on the mean and standard deviation for each
# measurement.
# -----------------------------------------------------------------------------

# extract standard deviation measurements
extract_std <- test_and_training %>% select(contains("-std()"))

# extract mean measurements
extract_mean <- test_and_training %>% select(contains("-mean()"))

# bind the extracted measurements together along with subjects and activity columns
extract_data <- bind_cols(test_and_training[,1:2], extract_std, extract_mean)

# -----------------------------------------------------------------------------
# 3. Uses descriptive activity names to name the activities in the data set
# -----------------------------------------------------------------------------

# replace 
for (ext in 1:nrow(extract_data)){
  for(act in 1:nrow(activity_labels)){
    actnum <- activity_labels[act,1]
    actlab <- activity_labels[act,2]
    if(extract_data[ext,2] == actnum){extract_data[ext,2] <- as.character(actlab)} 
  }
}

# -----------------------------------------------------------------------------
# 4. Appropriately labels the data set with descriptive variable names. 
# -----------------------------------------------------------------------------
# Create a dataframe to replace original abbriviated labels with their descriptions
# Descriptions are taked from README.txt of the original UCI HAR Dataset
descriptive_labels <- data.frame(
  Original = 
    c("tBody",
      "tGravity",
      "fBody",
      "Acc",
      "Gyro", 
      "Jerk", 
      "Mag", 
      "-X", 
      "-Y", 
      "-Z", 
      "mean()", 
      "std()"),
  Descriptive =
    c("body acceleration time ",
      "gravity acceleration time ",
      "frequency measurement ",
      "accelerometer 3-axial raw signal ",
      "gyroscope 3-axial raw signal ",
      "jerk ",
      "magnitude ",
      "direction X ",
      "direction Y ",
      "direction Z ",
      "Mean value ",
      "Standard deviation ")
  )

# Loop through the descriptive_labels and replace elements of extract_data variable names
for (descr in 1:nrow(descriptive_labels)){    
  names(extract_data) <- sub(descriptive_labels[descr,1], descriptive_labels[descr,2], names(extract_data))
}

# -----------------------------------------------------------------------------
# 5. From the data set in step 4, creates a second, independent tidy data set
# with the average of each variable for each activity and each subject
# -----------------------------------------------------------------------------

Tidy_Set <- group_by(extract_data, Subjects, Activity) %>% summarise_each(funs(mean))

write.table(Tidy_Set, file="./course_project_gcd/Tidy_Data.txt", row.name=FALSE)
