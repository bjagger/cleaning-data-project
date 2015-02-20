# cleaning-data-project
Coursera Getting and Cleaning Data Course Project

# Please use this to load and view the dataset into your R console:

address <- ""https://s3.amazonaws.com/coursera-uploads/user-d362c50645b5a613f6b7068e/973498/asst-3/f1c81510b89f11e494c47bcf999bcf59.txt"

address <- sub("^https", "http", address)

data <- read.table(url(address), header = TRUE)

View(data)

# Project Objective
Output a tidy data set, which has the following characteristics

 * Each variable forms a column.
 * Each observation forms a row.
 * Each type of observational unit forms a table.

 (taken from: http://www.jstatsoft.org/v59/i10/paper)

# Instructions
You should create one R script called run_analysis.R that does the following.
 * Merges the training and the test sets to create one data set.
 * Extracts only the measurements on the mean and standard deviation for each measurement.
 * Uses descriptive activity names to name the activities in the data set.
 * Appropriately labels the data set with descriptive variable names. 
 * From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Project Background
The data is downloaded from:
"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
The data results from an experiment which measured 30 human subjects performing 6 activities. A vector of over 500 variables called "features" forms each observation. Some of the subjects took part in the training phase, others in the test phase. There are over 10,000 observations in the combined datasets.
The features are described (see "features.info.txt") as produced by signals from accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ in a Samsung phone.

The download consists of several nested files. More information on the data is found in the "README" file included in the download.

We do not need all the files in the download. These are the only ones needed:
 * activity_labels.txt    
 * features.txt           
 * subject_test.txt  
 * X_test.txt        
 * y_test.txt        
 * subject_train.txt
 * X_train.txt      
 * y_train.txt 
      
Please see run_analysis.R for file paths and description of these files.      

# run_analysis (summary)
"features.txt" is a vector containing over 500 variables. A subset of this was created to provide an index of only those names containing "mean" or "std" (84 were found).
The two "X" datasets were bound together by rows, and the index was used to subset the resulting dataset of over 10,000 observations.
The dataset activity factor integers were replaed with descriptive names (e.g., "walking", "standing" from the "Y" data), and suitable variable names adapted from the unsuitable features names.
The dataset was then grouped by subject and activity and this was summarized to find the averages for each of the 84 variables.
Finally, the dataset was "melted" using the reshape2 package, in favour of this view:

"In reality, you need long-format data much more commonly than wide-format data."
(http://seananderson.ca/2013/10/19/reshape.html)

Please see the CodeBook for a description of how descriptive names replaced activity integers, and for a cross reference and description of variable namestween variable names.

run_analysis also describes what was done for each step of the project.

# Summary of Output
run_analysis outputs a data frame called "tidy_df"
str(tidy_df)
'data.frame':      15480 obs. of  4 variables:
      $ subject : int  1 1 1 1 1 1 2 2 2 2 ...
      $ activity: Factor w/ 6 levels "walking",
                  "walking_upstairs",..: 1 2 3 4 5 6 1 2 3 4 ...
      $ measure : Factor w/ 86 levels "time_domain_Body_Accel_mean_X",
                   ..: 1 1 1 1 1 1 1 1 1 1 ...
      $ mean    : num  0.277 0.255 0.289 0.261 0.279 ...