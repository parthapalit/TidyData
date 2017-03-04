Author: Partha Palit
Date: 3/4/2017
Contents: codebook for tidydata.txt

References: dplyr and stringr package cran pages + Stackoverflow

Packages used: stringr and dplyr

Explanation of code:
1. Read subject_train.txt as numeric using read.csv
	1.a) Add a header called Subject.ID
2. Read the features.txt file
	2.a) Extract the 2nd column and transpose it
3. Read the x_train.txt file without the header
	3.a) Add column names using the column names as defined by step (2.a) above. The file now has the measurements as well as the column headers
	3.b) A seq(1, nrow(step(3))) has been used with column name as RowSeq
	3.c) use data.frame (step(3a), step(3b)) to add a row number for every record in the file. This is to help verification of the final file. 
4. Read the y_train.txt file without the header
	4.a) Add columns called RowSeq and FileType (= Train) to the file using the mutate function in dplyr. The RowSeq will be used to inner join with (3.c). The FileType field helps identify the dataset after merge with test
5. Read the activity_labels.txt file
	5.a) Define column names as Activity.ID and Activity.description using dplyr::select
6. Combine datasets from steps 4 and 5 using dplyr::left_join using Activity.ID as key
7. Combine datasets from 6 and 3 to form the final train dataset using inner_join on RowSeq key. Please note that this dataset is NOT filtered for mean and std column names.
8. Create a separate dataset containing FileType, RowSeq, Subject.ID, Activity.ID and Activity.description
9. Now filter all colnames for 'mean' and 'std'. Please note that meanFreq is not considered for the final tidy dataset. This is the 'train' dataset.
10. Repeat steps 1 to 9 for the test files. Steps 2 and 5 were not repeated. The datasets created were reused. This will form the 'test' file dataset.
11. Now combine the 'train' and 'test' datasets using the rbind() function. The RowSeq and FileType columns are now included for the final dataset as it was used only for joins/verification
12.  Rename the field names
	12.a) Replace all field names starting with t with TDS (Time Domain Signal) and f with FDS (Frequency Domain Signal)
	12.b) Replace the () with '.' to make it cleaner
13. For dataset from step 12 - Group by Subject.ID and Activity.description and then summarize each of the columns using mean() (dplyr::group_by and dplyr::summarize_each)
14. Create the tidydata.txt file as required in step 5 of the assignment using row.names = FALSE

	
Codebook:
Subject.ID 	1
	1..30
Activity.description	2
	LAYING
	SITTING
	STANDING
	WALKING
	WALKING_DOWNSTAIRS
	WALKING_UPSTAIRS
Activity.ID		3
	1..6
	Mapping as defined by activity_labels.txt
	1 -	WALKING
	2 -	WALKING_UPSTAIRS
	3 -	WALKING_DOWNSTAIRS
	4 -	SITTING
	5 -	STANDING
	6 -	LAYING	
# Other measurement columns (mapping to the original file). Note: mean -> mean and std -> standard deviation. bounded within [-1,1]
Original name		New name
tBodyAcc.mean().X	TDS.BodyAcc.mean.X
tBodyAcc.mean().Y	TDS.BodyAcc.mean.Y
tBodyAcc.mean().Z	TDS.BodyAcc.mean.Z
tBodyAcc.std().X	TDS.BodyAcc.std.X
tBodyAcc.std().Y	TDS.BodyAcc.std.Y
tBodyAcc.std().Z	TDS.BodyAcc.std.Z
tGravityAcc.mean().X	TDS.GravityAcc.mean.X
tGravityAcc.mean().Y	TDS.GravityAcc.mean.Y
tGravityAcc.mean().Z	TDS.GravityAcc.mean.Z
tGravityAcc.std().X	TDS.GravityAcc.std.X
tGravityAcc.std().Y	TDS.GravityAcc.std.Y
tGravityAcc.std().Z	TDS.GravityAcc.std.Z
tBodyAccJerk.mean().X	TDS.BodyAccJerk.mean.X
tBodyAccJerk.mean().Y	TDS.BodyAccJerk.mean.Y
tBodyAccJerk.mean().Z	TDS.BodyAccJerk.mean.Z
tBodyAccJerk.std().X	TDS.BodyAccJerk.std.X
tBodyAccJerk.std().Y	TDS.BodyAccJerk.std.Y
tBodyAccJerk.std().Z	TDS.BodyAccJerk.std.Z
tBodyGyro.mean().X	TDS.BodyGyro.mean.X
tBodyGyro.mean().Y	TDS.BodyGyro.mean.Y
tBodyGyro.mean().Z	TDS.BodyGyro.mean.Z
tBodyGyro.std().X	TDS.BodyGyro.std.X
tBodyGyro.std().Y	TDS.BodyGyro.std.Y
tBodyGyro.std().Z	TDS.BodyGyro.std.Z
tBodyGyroJerk.mean().X	TDS.BodyGyroJerk.mean.X
tBodyGyroJerk.mean().Y	TDS.BodyGyroJerk.mean.Y
tBodyGyroJerk.mean().Z	TDS.BodyGyroJerk.mean.Z
tBodyGyroJerk.std().X	TDS.BodyGyroJerk.std.X
tBodyGyroJerk.std().Y	TDS.BodyGyroJerk.std.Y
tBodyGyroJerk.std().Z	TDS.BodyGyroJerk.std.Z
tBodyAccMag.mean()	TDS.BodyAccMag.mean
tBodyAccMag.std()	TDS.BodyAccMag.std
tGravityAccMag.mean()	TDS.GravityAccMag.mean
tGravityAccMag.std()	TDS.GravityAccMag.std
tBodyAccJerkMag.mean()	TDS.BodyAccJerkMag.mean
tBodyAccJerkMag.std()	TDS.BodyAccJerkMag.std
tBodyGyroMag.mean()	TDS.BodyGyroMag.mean
tBodyGyroMag.std()	TDS.BodyGyroMag.std
tBodyGyroJerkMag.mean()	TDS.BodyGyroJerkMag.mean
tBodyGyroJerkMag.std()	TDS.BodyGyroJerkMag.std
fBodyAcc.mean().X	FDS.BodyAcc.mean.X
fBodyAcc.mean().Y	FDS.BodyAcc.mean.Y
fBodyAcc.mean().Z	FDS.BodyAcc.mean.Z
fBodyAcc.std().X	FDS.BodyAcc.std.X
fBodyAcc.std().Y	FDS.BodyAcc.std.Y
fBodyAcc.std().Z	FDS.BodyAcc.std.Z
fBodyAccJerk.mean().X	FDS.BodyAccJerk.mean.X
fBodyAccJerk.mean().Y	FDS.BodyAccJerk.mean.Y
fBodyAccJerk.mean().Z	FDS.BodyAccJerk.mean.Z
fBodyAccJerk.std().X	FDS.BodyAccJerk.std.X
fBodyAccJerk.std().Y	FDS.BodyAccJerk.std.Y
fBodyAccJerk.std().Z	FDS.BodyAccJerk.std.Z
fBodyGyro.mean().X	FDS.BodyGyro.mean.X
fBodyGyro.mean().Y	FDS.BodyGyro.mean.Y
fBodyGyro.mean().Z	FDS.BodyGyro.mean.Z
fBodyGyro.std().X	FDS.BodyGyro.std.X
fBodyGyro.std().Y	FDS.BodyGyro.std.Y
fBodyGyro.std().Z	FDS.BodyGyro.std.Z
fBodyAccMag.mean()	FDS.BodyAccMag.mean
fBodyAccMag.std()	FDS.BodyAccMag.std
fBodyBodyAccJerkMag.mean()	FDS.BodyBodyAccJerkMag.mean
fBodyBodyAccJerkMag.std()	FDS.BodyBodyAccJerkMag.std
fBodyBodyGyroMag.mean()	FDS.BodyBodyGyroMag.mean
fBodyBodyGyroMag.std()	FDS.BodyBodyGyroMag.std
fBodyBodyGyroJerkMag.mean()	FDS.BodyBodyGyroJerkMag.mean
fBodyBodyGyroJerkMag.std()	FDS.BodyBodyGyroJerkMag.std
	
	
	

	
 


		