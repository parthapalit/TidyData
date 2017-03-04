Author: Partha Palit
Date: 3/4/2017
Contents: Explanation of code in run_analysis.R

Requirements for running the code and validating the final output

Directory structure of source files (please note the changes in the directory and subdirectory name):
	Train: ../UCI_HAR_Dataset/UCI_HAR_Dataset/train
		x_train.txt (measurements for train)
		y_train.txt (identifies actitivy ID)
		subject_train.txt (identifies the subject/person ID)	
	Test: ../UCI_HAR_Dataset/UCI_HAR_Dataset/test
		x_test.txt (measurements for test)
		y_test.txt (identifies actitivy ID)
		subject_test.txt (identifies the subject/person ID)
	Metadata: ../UCI_HAR_Dataset/UCI_HAR_Dataset/
		features.txt (contains measurements - used as column headers for tidydata.txt with certain modifications explained in codebook section)
		activity_labels.txt (translated to Activity.ID and Activity.description)
		features_info.txt (used as reference to translate the column headers for tidydata.txt)

How to verify:
	# Save run_analysis.R file to current directory
	# Source the file from current directory
	source('~/run_analysis.R')
	
	# run the function
	run_analysis()
	
	# Read the data after saving the tidydata.txt file from the github repo to a directory
	data <- read.table(<file_path>, header = TRUE) 
    View(data)
	Above the courtesy of David Hood (https://thoughtfulbloke.wordpress.com/2015/09/09/getting-and-cleaning-the-assignment/)

Codebook:
Please refer to Codebook.md file for instructions and prerequisites for running the code and viewing the final dataset. It also has details of the transformations in the code.