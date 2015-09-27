# Getting-and-Cleaning-Data--Course-Project
Getting and Cleaning Data Course Project

The script run_analysis.R does the following:

1. Merges the training and the test sets to create one data set.

2. Extracts only the measurements on the mean and standard deviation for each measurement. 

3. Uses descriptive activity names to name the activities in the data set

4. Appropriately labels the data set with descriptive variable names. 

5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
 
---------------------------------------------------------------------------------
1. Merges the training and the test sets to create one data set.
---------------------------------------------------------------------------------
The script starts with setting names for the files that will be used to data. Training and test (set, activity, and subjects), features and activity labels are loaded into dataframes as follows:

Training_set:  training set dataframe
Training_activity:  training activity dataframe
Training_subjects:  training subjects dataframe
Test_set: test set dataframe
Test_activity:  test activity dataframe
Test_subjects:  test subjects dataframe
features: features dataframe
activity_labels:  activity labels dataframe

Training and test data is then combined in training_df and test_df dataframes, features are assigned to header dataframe, and assigned as column names to training_df and test_df. First two columns are assinged "Subjects" and "Activity" names.

Finally, training and test data are combined in test_and_training dataframe.

---------------------------------------------------------------------------------
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
---------------------------------------------------------------------------------
Standard deviation and mean measurements are selected by searching for "-std()" and "-mean()" characters string in test_and_training variable names, and assigned to extract_std and extract_mean dataframes. These are merged together along with the SUbjects and Activity columns, and stored in extract_data_0

---------------------------------------------------------------------------------
3. Uses descriptive activity names to name the activities in the data set
---------------------------------------------------------------------------------
Activity labels are assigned to a new dataframe extract_data from dataframe activity_labels that stores data from activity_labels.txt file

---------------------------------------------------------------------------------
4. Appropriately labels the data set with descriptive variable names. 
---------------------------------------------------------------------------------
For the purpose of assigining appropriate descriptive variable names, I have created a dataframe descriptive_labels that stores parts of original variable names and their description from UCI HAR Dataset README.txt file.
The script loops through the descriptive_labels and replaces elements of extract_data variable names.

---------------------------------------------------------------------------------
5. From the data set in step 4, creates a second, independent tidy data set
with the average of each variable for each activity and each subject
---------------------------------------------------------------------------------
Tidy data set is created by grouping the extracted data extract_data by Subjects and Activity using group_by and calculating average of each variable for each activity by passing the mean function to summarise_each.
The data is then exported to Tidy_Data.txt


