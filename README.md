Please use this code to download and view the output dataset:	
```{r, eval=FALSE}	
address <- "https://s3.amazonaws.com/coursera-uploads/user-d362c50645b5a613f6b7068e/973498/asst-3/f1c81510b89f11e494c47bcf999bcf59.txt"	
address <- sub("^https", "http", address)	
data <- read.table(url(address), header = TRUE)	
View(data)	
```	
Please note, the run_analysis script starts with the assumption that the Samsung data is available in the working directory in an unzipped UCI HAR Dataset folder. (A description of the data is given at the end of this readme.)	

### run_analysis was written to fulfil the following instructions:		
You should create one R script called run_analysis.R that does the following.	
 * Merges the training and the test sets to create one data set.	
 * Extracts only the measurements on the mean and standard deviation for each measurement.	
 * Uses descriptive activity names to name the activities in the data set.	
 * Appropriately labels the data set with descriptive variable names. 
 * From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.	

### Script Description			
We do not need all of the files in the Samsung data download, only these:	
 * activity_labels.txt    
 * features.txt           
 * subject_test.txt  
 * X_test.txt        
 * y_test.txt        
 * subject_train.txt
 * X_train.txt      
 * y_train.txt 
      
(Please see run_analysis.R for file paths and description of these files, and description of each step in the script.)	      

"features.txt" is a vector containing over 500 variables. A subset of this was created to provide an index of only those names containing "mean" or "std". The subset contains 84 variables.  The two "X" datasets were bound together by rows, and the index was used to subset the resulting dataset of over 10,000 observations. 
The variable "activity" originally contained factor integers. These were replaced with descriptive names (e.g., "walking", "standing") taken from the "y" data. For the 84 variables, suitable variable names were adapted from the unsuitable features names. This is described in the codebook. 	
The dataset was then grouped by subject and activity and this was summarized to find the averages for each of the 84 variables.
Finally, the dataset was "melted" using the reshape2 package, in agreement with this view:

"In reality, you need long-format data much more commonly than wide-format data."
(http://seananderson.ca/2013/10/19/reshape.html)

Please see the CodeBook for a description of how descriptive names replaced activity integers, and for a cross reference and description of variable names.

## Output Structure		
run_analysis outputs a data frame called "tidy_df"	
str(tidy_df) 
'data.frame':      15480 obs. of  4 variables	
      $ subject : int  1 1 1 1 1 1 2 2 2 2 ...	
      $ activity: Factor w/ 6 levels "walking",	
                  "walking_upstairs",..: 1 2 3 4 5 6 1 2 3 4 ...	
      $ measure : Factor w/ 86 levels "time_domain_Body_Accel_mean_X",	
                   ..: 1 1 1 1 1 1 1 1 1 1 ...	
      $ mean    : num  0.277 0.255 0.289 0.261 0.279 ...	


## Samsung Data Background
The dataset is downloaded from:
"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
The dataset results from an experiment which measured 30 human subjects performing 6 activities. One set of subjects participated in the training phase, the other in the test phase.	
A vector of over 500 "features" from accelerometer and gyroscope 3-axial raw signals forms each observation. They are described in the "features.info.txt".	More information is found in the README file included in the download.