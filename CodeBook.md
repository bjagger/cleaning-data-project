### Variables in the tidy_df dataset
### "subject" (column 1)
This is a vector of integers from 1 to 30, which combines "subject_test" and "subject_train" data.

### "activity" (column 2)
This is a vector of factor levels from 1 to 6, which combines "y_test" and "y_train" data. 
 * activity labels for the levels are taken from the "activity_labels.txt" file.
   1. "walking"
   2. "walking_upstairs"
   3. "walking_downstairs""
   4. "sitting"
   5. "standing"
   6. "laying"

The following code was used to replace integer with activity descriptions.

```{r, eval=FALSE}
levels(merged_df2$V1.1)[1:6] <- activity_names[1:6]
```
Feature names were found to be unsuitable for use as variable names. The make.names function was applied.
However, this left trailing periods that were also unsuitable, and very long column names in this were being truncated.
Moreover, although the names could be used in this form, they were still highly unreadable.
Therefore, the names were changed by adding underscores to increase spacing and make them easier to read.
In one case a correction was applied to the original name (BodyBody became Body).

The original feature names were turned into variable labels in the following steps.

```{r, eval=FALSE}
var_names2[1:40] <- str_replace(var_names2[1:40], t, time_domain_)
var_names2[80:83] <- str_replace(var_names2[80:83], t, time_domain_)
var_names2[41:79] <- str_replace(var_names2[41:79], f, freq_domain_)
var_names2 <- str_replace(var_names2, angle, angle_)
var_names2 <- str_replace(var_names2, BodyBody, Body) ## this is a correction
var_names2 <- str_replace(var_names2, Body, Body_)
var_names2 <- str_replace(var_names2, Acc, Accel_)
var_names2 <- str_replace(var_names2, Gyro, Gyro_)
var_names2[80] <- str_replace(var_names2[80], gravity, _gravity)
var_names2[81:86] <- str_replace(var_names2[81:86], gravity, _gravity_)
var_names2 <- str_replace(var_names2, Gravity, Gravity_)
var_names2 <- str_replace(var_names2, Jerk, Jerk_)
var_names2 <- str_replace(var_names2, Mag, Mag_)
var_names2[1:83] <- str_replace(var_names2[1:83], X, _X)
var_names2[1:83] <- str_replace(var_names2[1:83], Y, _Y)
var_names2[1:83] <- str_replace(var_names2[1:83], Z, _Z)
var_names2 <- str_replace(var_names2, meanFreq, mean_Freq)
```

original "features"                  | variables
------------------------------------ | ------------------------------------
tBodyAcc-mean()-X                    | time_domain_Body_Accel_mean_X
tBodyAcc-mean()-Y	                 | time_domain_Body_Accel_mean_Y
tBodyAcc-mean()-Z	                 | time_domain_Body_Accel_mean_Z
tBodyAcc-std()-X	                 | time_domain_Body_Accel_std_X
tBodyAcc-std()-Y	                 | time_domain_Body_Accel_std_Y
tBodyAcc-std()-Z	                 | time_domain_Body_Accel_std_Z
tGravityAcc-mean()-X	             | time_domain_Gravity_Accel_mean_X
tGravityAcc-mean()-Y	             | time_domain_Gravity_Accel_mean_Y
tGravityAcc-mean()-Z	             | time_domain_Gravity_Accel_mean_Z
tGravityAcc-std()-X	                 | time_domain_Gravity_Accel_std_X
tGravityAcc-std()-Y	                 | time_domain_Gravity_Accel_std_Y
tGravityAcc-std()-Z	                 | time_domain_Gravity_Accel_std_Z
tBodyAccJerk-mean()-X                | time_domain_Body_Accel_Jerk_mean_X
tBodyAccJerk-mean()-Y                | time_domain_Body_Accel_Jerk_mean_Y
tBodyAccJerk-mean()-Z                | time_domain_Body_Accel_Jerk_mean_Z
tBodyAccJerk-std()-X	             | time_domain_Body_Accel_Jerk_std_X
tBodyAccJerk-std()-Y	             | time_domain_Body_Accel_Jerk_std_Y
tBodyAccJerk-std()-Z	             | time_domain_Body_Accel_Jerk_std_Z
tBodyGyro-mean()-X	                 | time_domain_Body_Gyro_mean_X
tBodyGyro-mean()-Y	                 | time_domain_Body_Gyro_mean_Y
tBodyGyro-mean()-Z	                 | time_domain_Body_Gyro_mean_Z
tBodyGyro-std()-X	                 | time_domain_Body_Gyro_std_X
tBodyGyro-std()-Y	                 | time_domain_Body_Gyro_std_Y
tBodyGyro-std()-Z	                 | time_domain_Body_Gyro_std_Z
tBodyGyroJerk-mean()-X               | time_domain_Body_Gyro_Jerk_mean_X
tBodyGyroJerk-mean()-Y               | time_domain_Body_Gyro_Jerk_mean_Y
tBodyGyroJerk-mean()-Z               | time_domain_Body_Gyro_Jerk_mean_Z
tBodyGyroJerk-std()-X                | time_domain_Body_Gyro_Jerk_std_X
tBodyGyroJerk-std()-Y                | time_domain_Body_Gyro_Jerk_std_Y
tBodyGyroJerk-std()-Z                | time_domain_Body_Gyro_Jerk_std_Z
tBodyAccMag-mean()	                 | time_domain_Body_Accel_Mag_mean
tBodyAccMag-std()	                 | time_domain_Body_Accel_Mag_std
tGravityAccMag-mean()                | time_domain_Gravity_Accel_Mag_mean
tGravityAccMag-std()	             | time_domain_Gravity_Accel_Mag_std
tBodyAccJerkMag-mean()               | time_domain_Body_Accel_Jerk_Mag_mean
tBodyAccJerkMag-std()                | time_domain_Body_Accel_Jerk_Mag_std
tBodyGyroMag-mean()	                 | time_domain_Body_Gyro_Mag_mean
tBodyGyroMag-std()	                 | time_domain_Body_Gyro_Mag_std
tBodyGyroJerkMag-mean()              | time_domain_Body_Gyro_Jerk_Mag_mean
tBodyGyroJerkMag-std()               | time_domain_Body_Gyro_Jerk_Mag_std
fBodyAcc-mean()-X	                 | freq_domain_Body_Accel_mean_X
fBodyAcc-mean()-Y	                 | freq_domain_Body_Accel_mean_Y
fBodyAcc-mean()-Z	                 | freq_domain_Body_Accel_mean_Z
fBodyAcc-std()-X	                 | freq_domain_Body_Accel_std_X
fBodyAcc-std()-Y	                 | freq_domain_Body_Accel_std_Y
fBodyAcc-std()-Z	                 | freq_domain_Body_Accel_std_Z
fBodyAcc-meanFreq()-X                | freq_domain_Body_Accel_mean_Freq_X
fBodyAcc-meanFreq()-Y                | freq_domain_Body_Accel_mean_Freq_Y
fBodyAcc-meanFreq()-Z                | freq_domain_Body_Accel_mean_Freq_Z
fBodyAccJerk-mean()-X                | freq_domain_Body_Accel_Jerk_mean_X
fBodyAccJerk-mean()-Y                | freq_domain_Body_Accel_Jerk_mean_Y
fBodyAccJerk-mean()-Z                | freq_domain_Body_Accel_Jerk_mean_Z
fBodyAccJerk-std()-X	             | freq_domain_Body_Accel_Jerk_std_X
fBodyAccJerk-std()-Y	             | freq_domain_Body_Accel_Jerk_std_Y
fBodyAccJerk-std()-Z	             | freq_domain_Body_Accel_Jerk_std_Z
fBodyAccJerk-meanFreq()-X            | freq_domain_Body_Accel_Jerk_mean_Freq_X
fBodyAccJerk-meanFreq()-Y            | freq_domain_Body_Accel_Jerk_mean_Freq_Y
fBodyAccJerk-meanFreq()-Z            | freq_domain_Body_Accel_Jerk_mean_Freq_Z
fBodyGyro-mean()-X	                 | freq_domain_Body_Gyro_mean_X
fBodyGyro-mean()-Y	                 | freq_domain_Body_Gyro_mean_Y
fBodyGyro-mean()-Z	                 | freq_domain_Body_Gyro_mean_Z
fBodyGyro-std()-X	                 | freq_domain_Body_Gyro_std_X
fBodyGyro-std()-Y	                 | freq_domain_Body_Gyro_std_Y
fBodyGyro-std()-Z	                 | freq_domain_Body_Gyro_std_Z
fBodyGyro-meanFreq()-X               | freq_domain_Body_Gyro_mean_Freq_X
fBodyGyro-meanFreq()-Y               | freq_domain_Body_Gyro_mean_Freq_Y
fBodyGyro-meanFreq()-Z               | freq_domain_Body_Gyro_mean_Freq_Z
fBodyAccMag-mean()	                 | freq_domain_Body_Accel_Mag_mean
fBodyAccMag-std()	                 | freq_domain_Body_Accel_Mag_std
fBodyAccMag-meanFreq()               | freq_domain_Body_Accel_Mag_mean_Freq
fBodyBodyAccJerkMag-mean()           | freq_domain_Body_Accel_Jerk_Mag_mean
fBodyBodyAccJerkMag-std()	         | freq_domain_Body_Accel_Jerk_Mag_std
fBodyBodyAccJerkMag-meanFreq()       | freq_domain_Body_Accel_Jerk_Mag_mean_Freq
fBodyBodyGyroMag-mean()	             | freq_domain_Body_Gyro_Mag_mean
fBodyBodyGyroMag-std()	             | freq_domain_Body_Gyro_Mag_std
fBodyBodyGyroMag-meanFreq()          | freq_domain_Body_Gyro_Mag_mean_Freq
fBodyBodyGyroJerkMag-mean()          | freq_domain_Body_Gyro_Jerk_Mag_mean
fBodyBodyGyroJerkMag-std()	       	 | freq_domain_Body_Gyro_Jerk_Mag_std
fBodyBodyGyroJerkMag-meanFreq()      | freq_domain_Body_Gyro_Jerk_Mag_mean_Freq
angle(tBodyAccMean,gravity)	       	 | angle_time_domain_Body_Accel_Mean_gravity
angle(tBodyAccJerkMean),gravityMean) |  angle_time_domain_Body_Accel_Jerk_Mean_gravity_Mean
angle(tBodyGyroMean,gravityMean)	 | angle_time_domain_Body_Gyro_Mean_gravity_Mean
angle(tBodyGyroJerkMean,gravityMean) | angle_time_domain_Body_Gyro_Jerk_Mean_gravity_Mean
angle(X,gravityMean)	             | angle_X_gravity_Mean
angle(Y,gravityMean)	             | angle_Y_gravity_Mean
angle(Z,gravityMean)	             | angle_Z_gravity_Mean