
#### Summary ########################################################
#####################################################################
# run_analysis outputs a data frame called "tidy_df"
# str(tidy_df)
# 'data.frame':      15480 obs. of  4 variables:
#       $ subject : int  1 1 1 1 1 1 2 2 2 2 ...
#       $ activity: Factor w/ 6 levels "walking",
#                   "walking_upstairs",..: 1 2 3 4 5 6 1 2 3 4 ...
#       $ measure : Factor w/ 86 levels "time_domain_Body_Accel_mean_X",
#                    ..: 1 1 1 1 1 1 1 1 1 1 ...
#       $ mean    : num  0.277 0.255 0.289 0.261 0.279 ...
#####################################################################
#####################################################################

library(dplyr)
library(stringr)
library(reshape2)

# Here are all the nested files
file.names <- list.files("./UCI HAR Dataset", full.names = TRUE, recursive = TRUE)

# These are the only files we need:
# print(file.names[c(1,2,14:16, 26:28)])
# "./UCI HAR Dataset/activity_labels.txt"    
# "./UCI HAR Dataset/features.txt"           
# "./UCI HAR Dataset/test/subject_test.txt"  
# "./UCI HAR Dataset/test/X_test.txt"        
# "./UCI HAR Dataset/test/y_test.txt"        
# "./UCI HAR Dataset/train/subject_train.txt"
# "./UCI HAR Dataset/train/X_train.txt"      
# "./UCI HAR Dataset/train/y_train.txt" 

# Here's what they contain:
# file.names[1] contains descriptive activity names
# file.names[2] contains the "561 features" that will
# be modified to form variable names
# file.names[14] contains "subject_test.txt",
# file.names[15] contains "X_test.txt",
# file.names[16] contains "y_test.txt",
# file.names[26] contains "subject_train.txt",
# file.names[27] contains "X_train.txt",
# file.names[28] contains "y_train.txt"

###############  Steps of the Analysis  #################
#########################################################

# Step 1
# Merge (bind rows) of test data to training data.

# Step 1.1
# Read each of the "X" data frames
x_test_df <- tbl_df(read.table(file.names[15], colClasses = "numeric"))
x_train_df <- tbl_df(read.table(file.names[27], colClasses = "numeric"))

# View(x_test_df)
# View(x_train_df)

# Step 1.2
# For each of the "X" data frames ("test" and "train")
# bind its "subject" and "y" columns to be 1st and 2nd columns.

# Step 1.2.1
# Read the "subject" and "y" data sets. 
subject_test_df <- tbl_df(read.table(file.names[14], colClasses = "integer"))
subject_train_df <- tbl_df(read.table(file.names[26], colClasses = "integer"))
y_test_df <- tbl_df(read.table(file.names[16], colClasses = "factor"))
y_train_df <- tbl_df(read.table(file.names[28], colClasses = "factor"))

# Step 1.2.2
# Bind the columns.
x_test_df2 <- bind_cols(subject_test_df,
                        y_test_df,
                        x_test_df)

x_train_df2 <- bind_cols(subject_train_df,
                         y_train_df,
                         x_train_df)

# Step 1.3
# Make all column names unique (the first 3 currently are "V1"
# and must be made unique).

colnames(x_train_df2) <- colnames(x_test_df2) <- make.names(
      names(x_test_df2), unique = TRUE) 

# View(x_test_df2)
# View(x_train_df2)

# Step 1.4
# Merge (this is not really merge but rather binding of rows.)

merged_df <- bind_rows(x_train_df2, x_test_df2)

# View(merged_df)

# Step 2
# Extract only the measurements on the mean
# and standard deviation for each measurement.

# Step 2.1
# Get an index of names containing "mean" or "std" from the
# "561 features". The index will be used to subset columns of merged_df.
original_features <- tbl_df(read.table(file.names[2],
                                       colClasses = "character"))

mean_features <- which(str_detect(original_features$V2, ignore.case("mean")))
std_features <- which(str_detect(original_features$V2, ignore.case("std")))
features_index <- sort(union(mean_features, std_features))

# Step 2.2
# subset by "subject", "activity" and "features_index".
# All these columns will receive descriptive labels in Step 4.
merged_df2 <- merged_df %>%
      select(1, 2, features_index + 2)

# View(merged_df2)

# Step 3
# Use descriptive activity names to name the activities in the data set.
activity_names <- tbl_df(read.table(file.names[1], stringsAsFactors = FALSE))
activity_names <- tolower(activity_names$V2[1:6])  ## lower case looks better 

# Step 3.2
# Replace activity integer values (the "y" data in column 2)
# with activity names. Column 2 is class = factor so we can do
# this using levels.
levels(merged_df2$V1.1)[1:6] <- activity_names[1:6]

# View(merged_df2)

# Step 4
# Appropriately label the data set with descriptive variable
# names.

# Step 4.1
# Make the subset of original feature names suitable for
# variable names. The following shows changes to original
# feature names. The changes generally follow recommendations
# in "Post 4" at:
# https://class.coursera.org/getdata-011/forum/search?q=variable+names#15-state-query=variable+names

# remove all parentheses, dashes, and any other unsuitable characters
var_names1 <- make.names(original_features$V2[features_index])

# remove all the decimal points that resulted from "make.names". These
# tend to get truncated in long column names.
var_names2 <- str_replace_all(var_names1, "\\.", "")

# make the following changes to make variable names more readable
var_names2[1:40] <- str_replace(var_names2[1:40], "t", "time_domain_")
var_names2[80:83] <- str_replace(var_names2[80:83], "t", "time_domain_")
var_names2[41:79] <- str_replace(var_names2[41:79], "f", "freq_domain_")
var_names2 <- str_replace(var_names2, "angle", "angle_")
var_names2 <- str_replace(var_names2, "BodyBody", "Body") ## this is a correction
var_names2 <- str_replace(var_names2, "Body", "Body_")
var_names2 <- str_replace(var_names2, "Acc", "Accel_")
var_names2 <- str_replace(var_names2, "Gyro", "Gyro_")
var_names2[80] <- str_replace(var_names2[80], "gravity", "_gravity")
var_names2[81:86] <- str_replace(var_names2[81:86], "gravity", "_gravity_")
var_names2 <- str_replace(var_names2, "Gravity", "Gravity_")
var_names2 <- str_replace(var_names2, "Jerk", "Jerk_")
var_names2 <- str_replace(var_names2, "Mag", "Mag_")
var_names2[1:83] <- str_replace(var_names2[1:83], "X", "_X")
var_names2[1:83] <- str_replace(var_names2[1:83], "Y", "_Y")
var_names2[1:83] <- str_replace(var_names2[1:83], "Z", "_Z")
var_names2 <- str_replace(var_names2, "meanFreq", "mean_Freq")

# Step 4.1 - label columns, starting with col.1 and col.2.
colnames(merged_df2)[1:2] <- c("subject", "activity")

# replace the remaining 84 labels with var_names2
colnames(merged_df2)[3:ncol(merged_df2)] <- var_names2

# View(merged_df2)

# Step 5.
# From the data set in Step 4, create a second, independent
# tidy data set with the average of each variable for each
# activity and each subject.

# Step 5.1
# Summarize average by subject and activity.

wide_df <- merged_df2 %>%
      group_by(subject, activity) %>%
      summarize("time_domain_Body_Accel_mean_X" = mean(time_domain_Body_Accel_mean_X),
                "time_domain_Body_Accel_mean_Y" = mean(time_domain_Body_Accel_mean_Y),                      
                "time_domain_Body_Accel_mean_Z" = mean(time_domain_Body_Accel_mean_Z),                      
                "time_domain_Body_Accel_std_X" = mean(time_domain_Body_Accel_std_X),                       
                "time_domain_Body_Accel_std_Y" = mean(time_domain_Body_Accel_std_Y),                       
                "time_domain_Body_Accel_std_Z" = mean(time_domain_Body_Accel_std_Z),                       
                "time_domain_Gravity_Accel_mean_X" = mean(time_domain_Gravity_Accel_mean_X),                   
                "time_domain_Gravity_Accel_mean_Y" = mean(time_domain_Gravity_Accel_mean_Y),                   
                "time_domain_Gravity_Accel_mean_Z" = mean(time_domain_Gravity_Accel_mean_Z),                   
                "time_domain_Gravity_Accel_std_X" = mean(time_domain_Gravity_Accel_std_X),                    
                "time_domain_Gravity_Accel_std_Y" = mean(time_domain_Gravity_Accel_std_Y),                    
                "time_domain_Gravity_Accel_std_Z" = mean(time_domain_Gravity_Accel_std_Z),                    
                "time_domain_Body_Accel_Jerk_mean_X" = mean(time_domain_Body_Accel_Jerk_mean_X),                 
                "time_domain_Body_Accel_Jerk_mean_Y" = mean(time_domain_Body_Accel_Jerk_mean_Y),                 
                "time_domain_Body_Accel_Jerk_mean_Z" = mean(time_domain_Body_Accel_Jerk_mean_Z),                 
                "time_domain_Body_Accel_Jerk_std_X" = mean(time_domain_Body_Accel_Jerk_std_X),                  
                "time_domain_Body_Accel_Jerk_std_Y" = mean(time_domain_Body_Accel_Jerk_std_Y),                  
                "time_domain_Body_Accel_Jerk_std_Z" = mean(time_domain_Body_Accel_Jerk_std_Z),                  
                "time_domain_Body_Gyro_mean_X" = mean(time_domain_Body_Gyro_mean_X),                       
                "time_domain_Body_Gyro_mean_Y" = mean(time_domain_Body_Gyro_mean_Y),                       
                "time_domain_Body_Gyro_mean_Z" = mean(time_domain_Body_Gyro_mean_Z),                       
                "time_domain_Body_Gyro_std_X" = mean(time_domain_Body_Gyro_std_X),                        
                "time_domain_Body_Gyro_std_Y" = mean(time_domain_Body_Gyro_std_Y),                        
                "time_domain_Body_Gyro_std_Z" = mean(time_domain_Body_Gyro_std_Z),                        
                "time_domain_Body_Gyro_Jerk_mean_X" = mean(time_domain_Body_Gyro_Jerk_mean_X),                  
                "time_domain_Body_Gyro_Jerk_mean_Y" = mean(time_domain_Body_Gyro_Jerk_mean_Y),                  
                "time_domain_Body_Gyro_Jerk_mean_Z" = mean(time_domain_Body_Gyro_Jerk_mean_Z),                  
                "time_domain_Body_Gyro_Jerk_std_X" = mean(time_domain_Body_Gyro_Jerk_std_X),                   
                "time_domain_Body_Gyro_Jerk_std_Y" = mean(time_domain_Body_Gyro_Jerk_std_Y),                   
                "time_domain_Body_Gyro_Jerk_std_Z" = mean(time_domain_Body_Gyro_Jerk_std_Z),                   
                "time_domain_Body_Accel_Mag_mean" = mean(time_domain_Body_Accel_Mag_mean),                    
                "time_domain_Body_Accel_Mag_std" = mean(time_domain_Body_Accel_Mag_std),                     
                "time_domain_Gravity_Accel_Mag_mean" = mean(time_domain_Gravity_Accel_Mag_mean),                 
                "time_domain_Gravity_Accel_Mag_std" = mean(time_domain_Gravity_Accel_Mag_std),                  
                "time_domain_Body_Accel_Jerk_Mag_mean" = mean(time_domain_Body_Accel_Jerk_Mag_mean),               
                "time_domain_Body_Accel_Jerk_Mag_std" = mean(time_domain_Body_Accel_Jerk_Mag_std),                
                "time_domain_Body_Gyro_Mag_mean" = mean(time_domain_Body_Gyro_Mag_mean),                     
                "time_domain_Body_Gyro_Mag_std" = mean(time_domain_Body_Gyro_Mag_std),                      
                "time_domain_Body_Gyro_Jerk_Mag_mean" = mean(time_domain_Body_Gyro_Jerk_Mag_mean),                
                "time_domain_Body_Gyro_Jerk_Mag_std" = mean(time_domain_Body_Gyro_Jerk_Mag_std),                 
                "freq_domain_Body_Accel_mean_X" = mean(freq_domain_Body_Accel_mean_X),                      
                "freq_domain_Body_Accel_mean_Y" = mean(freq_domain_Body_Accel_mean_Y),                      
                "freq_domain_Body_Accel_mean_Z" = mean(freq_domain_Body_Accel_mean_Z),                      
                "freq_domain_Body_Accel_std_X" = mean(freq_domain_Body_Accel_std_X),                       
                "freq_domain_Body_Accel_std_Y" = mean(freq_domain_Body_Accel_std_Y),                       
                "freq_domain_Body_Accel_std_Z" = mean(freq_domain_Body_Accel_std_Z),                       
                "freq_domain_Body_Accel_mean_Freq_X" = mean(freq_domain_Body_Accel_mean_Freq_X),                 
                "freq_domain_Body_Accel_mean_Freq_Y" = mean(freq_domain_Body_Accel_mean_Freq_Y),                 
                "freq_domain_Body_Accel_mean_Freq_Z" = mean(freq_domain_Body_Accel_mean_Freq_Z),                 
                "freq_domain_Body_Accel_Jerk_mean_X" = mean(freq_domain_Body_Accel_Jerk_mean_X),                 
                "freq_domain_Body_Accel_Jerk_mean_Y" = mean(freq_domain_Body_Accel_Jerk_mean_Y),                 
                "freq_domain_Body_Accel_Jerk_mean_Z" = mean(freq_domain_Body_Accel_Jerk_mean_Z),                 
                "freq_domain_Body_Accel_Jerk_std_X" = mean(freq_domain_Body_Accel_Jerk_std_X),                  
                "freq_domain_Body_Accel_Jerk_std_Y" = mean(freq_domain_Body_Accel_Jerk_std_Y),                  
                "freq_domain_Body_Accel_Jerk_std_Z" = mean(freq_domain_Body_Accel_Jerk_std_Z),                  
                "freq_domain_Body_Accel_Jerk_mean_Freq_X" = mean(freq_domain_Body_Accel_Jerk_mean_Freq_X),            
                "freq_domain_Body_Accel_Jerk_mean_Freq_Y" = mean(freq_domain_Body_Accel_Jerk_mean_Freq_Y),            
                "freq_domain_Body_Accel_Jerk_mean_Freq_Z" = mean(freq_domain_Body_Accel_Jerk_mean_Freq_Z),            
                "freq_domain_Body_Gyro_mean_X" = mean(freq_domain_Body_Gyro_mean_X),                       
                "freq_domain_Body_Gyro_mean_Y" = mean(freq_domain_Body_Gyro_mean_Y),                       
                "freq_domain_Body_Gyro_mean_Z" = mean(freq_domain_Body_Gyro_mean_Z),                       
                "freq_domain_Body_Gyro_std_X" = mean(freq_domain_Body_Gyro_std_X),                        
                "freq_domain_Body_Gyro_std_Y" = mean(freq_domain_Body_Gyro_std_Y),                        
                "freq_domain_Body_Gyro_std_Z" = mean(freq_domain_Body_Gyro_std_Z),                        
                "freq_domain_Body_Gyro_mean_Freq_X" = mean(freq_domain_Body_Gyro_mean_Freq_X),                  
                "freq_domain_Body_Gyro_mean_Freq_Y" = mean(freq_domain_Body_Gyro_mean_Freq_Y),                  
                "freq_domain_Body_Gyro_mean_Freq_Z" = mean(freq_domain_Body_Gyro_mean_Freq_Z),                  
                "freq_domain_Body_Accel_Mag_mean" = mean(freq_domain_Body_Accel_Mag_mean),                    
                "freq_domain_Body_Accel_Mag_std" = mean(freq_domain_Body_Accel_Mag_std),                     
                "freq_domain_Body_Accel_Mag_mean_Freq" = mean(freq_domain_Body_Accel_Mag_mean_Freq),               
                "freq_domain_Body_Accel_Jerk_Mag_mean" = mean(freq_domain_Body_Accel_Jerk_Mag_mean),               
                "freq_domain_Body_Accel_Jerk_Mag_std" = mean(freq_domain_Body_Accel_Jerk_Mag_std),                
                "freq_domain_Body_Accel_Jerk_Mag_mean_Freq" = mean(freq_domain_Body_Accel_Jerk_Mag_mean_Freq),          
                "freq_domain_Body_Gyro_Mag_mean" = mean(freq_domain_Body_Gyro_Mag_mean),                     
                "freq_domain_Body_Gyro_Mag_std" = mean(freq_domain_Body_Gyro_Mag_std),                      
                "freq_domain_Body_Gyro_Mag_mean_Freq" = mean(freq_domain_Body_Gyro_Mag_mean_Freq),                
                "freq_domain_Body_Gyro_Jerk_Mag_mean" = mean(freq_domain_Body_Gyro_Jerk_Mag_mean),                
                "freq_domain_Body_Gyro_Jerk_Mag_std" = mean(freq_domain_Body_Gyro_Jerk_Mag_std),                 
                "freq_domain_Body_Gyro_Jerk_Mag_mean_Freq" = mean(freq_domain_Body_Gyro_Jerk_Mag_mean_Freq),           
                "angle_time_domain_Body_Accel_Mean_gravity" = mean(angle_time_domain_Body_Accel_Mean_gravity),         
                "angle_time_domain_Body_Accel_Jerk_Mean_gravity_Mean" = mean(angle_time_domain_Body_Accel_Jerk_Mean_gravity_Mean),
                "angle_time_domain_Body_Gyro_Mean_gravity_Mean" = mean(angle_time_domain_Body_Gyro_Mean_gravity_Mean),      
                "angle_time_domain_Body_Gyro_Jerk_Mean_gravity_Mean" = mean(angle_time_domain_Body_Gyro_Jerk_Mean_gravity_Mean), 
                "angle_X_gravity_Mean" = mean(angle_X_gravity_Mean),                               
                "angle_Y_gravity_Mean" = mean(angle_Y_gravity_Mean),                               
                "angle_Z_gravity_Mean" = mean(angle_Z_gravity_Mean))

# View(wide_df)

# Although the wide version is acceptable, I prefer the melted
# version.

tidy_df <- melt(wide_df, id.vars=c("subject", "activity"),
                measure.vars=c("time_domain_Body_Accel_mean_X",
                               "time_domain_Body_Accel_mean_Y",                      
                               "time_domain_Body_Accel_mean_Z",                      
                               "time_domain_Body_Accel_std_X",                       
                               "time_domain_Body_Accel_std_Y",                       
                               "time_domain_Body_Accel_std_Z",                       
                               "time_domain_Gravity_Accel_mean_X",                   
                               "time_domain_Gravity_Accel_mean_Y",                   
                               "time_domain_Gravity_Accel_mean_Z",                   
                               "time_domain_Gravity_Accel_std_X",                    
                               "time_domain_Gravity_Accel_std_Y",                    
                               "time_domain_Gravity_Accel_std_Z",                    
                               "time_domain_Body_Accel_Jerk_mean_X",                 
                               "time_domain_Body_Accel_Jerk_mean_Y",                 
                               "time_domain_Body_Accel_Jerk_mean_Z",                 
                               "time_domain_Body_Accel_Jerk_std_X",                  
                               "time_domain_Body_Accel_Jerk_std_Y",                  
                               "time_domain_Body_Accel_Jerk_std_Z",                  
                               "time_domain_Body_Gyro_mean_X",                       
                               "time_domain_Body_Gyro_mean_Y",                       
                               "time_domain_Body_Gyro_mean_Z",                       
                               "time_domain_Body_Gyro_std_X",                        
                               "time_domain_Body_Gyro_std_Y",                        
                               "time_domain_Body_Gyro_std_Z",                        
                               "time_domain_Body_Gyro_Jerk_mean_X",                  
                               "time_domain_Body_Gyro_Jerk_mean_Y",                  
                               "time_domain_Body_Gyro_Jerk_mean_Z",                  
                               "time_domain_Body_Gyro_Jerk_std_X",                   
                               "time_domain_Body_Gyro_Jerk_std_Y",                   
                               "time_domain_Body_Gyro_Jerk_std_Z",                   
                               "time_domain_Body_Accel_Mag_mean",                    
                               "time_domain_Body_Accel_Mag_std",                     
                               "time_domain_Gravity_Accel_Mag_mean",                 
                               "time_domain_Gravity_Accel_Mag_std",                  
                               "time_domain_Body_Accel_Jerk_Mag_mean",               
                               "time_domain_Body_Accel_Jerk_Mag_std",                
                               "time_domain_Body_Gyro_Mag_mean",                     
                               "time_domain_Body_Gyro_Mag_std",                      
                               "time_domain_Body_Gyro_Jerk_Mag_mean",                
                               "time_domain_Body_Gyro_Jerk_Mag_std",                 
                               "freq_domain_Body_Accel_mean_X",                      
                               "freq_domain_Body_Accel_mean_Y",                      
                               "freq_domain_Body_Accel_mean_Z",                      
                               "freq_domain_Body_Accel_std_X",                       
                               "freq_domain_Body_Accel_std_Y",                       
                               "freq_domain_Body_Accel_std_Z",                       
                               "freq_domain_Body_Accel_mean_Freq_X",                 
                               "freq_domain_Body_Accel_mean_Freq_Y",                 
                               "freq_domain_Body_Accel_mean_Freq_Z",                 
                               "freq_domain_Body_Accel_Jerk_mean_X",                 
                               "freq_domain_Body_Accel_Jerk_mean_Y",                 
                               "freq_domain_Body_Accel_Jerk_mean_Z",                 
                               "freq_domain_Body_Accel_Jerk_std_X",                  
                               "freq_domain_Body_Accel_Jerk_std_Y",                  
                               "freq_domain_Body_Accel_Jerk_std_Z",                  
                               "freq_domain_Body_Accel_Jerk_mean_Freq_X",            
                               "freq_domain_Body_Accel_Jerk_mean_Freq_Y",            
                               "freq_domain_Body_Accel_Jerk_mean_Freq_Z",            
                               "freq_domain_Body_Gyro_mean_X",                       
                               "freq_domain_Body_Gyro_mean_Y",                       
                               "freq_domain_Body_Gyro_mean_Z",                       
                               "freq_domain_Body_Gyro_std_X",                        
                               "freq_domain_Body_Gyro_std_Y",                        
                               "freq_domain_Body_Gyro_std_Z",                        
                               "freq_domain_Body_Gyro_mean_Freq_X",                  
                               "freq_domain_Body_Gyro_mean_Freq_Y",                  
                               "freq_domain_Body_Gyro_mean_Freq_Z",                  
                               "freq_domain_Body_Accel_Mag_mean",                    
                               "freq_domain_Body_Accel_Mag_std",                     
                               "freq_domain_Body_Accel_Mag_mean_Freq",               
                               "freq_domain_Body_Accel_Jerk_Mag_mean",               
                               "freq_domain_Body_Accel_Jerk_Mag_std",                
                               "freq_domain_Body_Accel_Jerk_Mag_mean_Freq",          
                               "freq_domain_Body_Gyro_Mag_mean",                     
                               "freq_domain_Body_Gyro_Mag_std",                      
                               "freq_domain_Body_Gyro_Mag_mean_Freq",                
                               "freq_domain_Body_Gyro_Jerk_Mag_mean",                
                               "freq_domain_Body_Gyro_Jerk_Mag_std",                 
                               "freq_domain_Body_Gyro_Jerk_Mag_mean_Freq",           
                               "angle_time_domain_Body_Accel_Mean_gravity",         
                               "angle_time_domain_Body_Accel_Jerk_Mean_gravity_Mean",
                               "angle_time_domain_Body_Gyro_Mean_gravity_Mean",      
                               "angle_time_domain_Body_Gyro_Jerk_Mean_gravity_Mean", 
                               "angle_X_gravity_Mean",                               
                               "angle_Y_gravity_Mean",                               
                               "angle_Z_gravity_Mean"),
                variable.name = "measure", value.name = "mean")

# arrange according to groups
tidy_df <-  tidy_df %>%   
      arrange(subject, activity)

# View(tidy_df)

# Output dataset per instruction

write.table(tidy_df, file = "./ tidy_df.txt", row.names = FALSE)