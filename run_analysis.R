library(dplyr)
library(stringr)

options(stringsAsFactors = FALSE)
run_analysis <- function() {
        
        # Reading the subject train file in a numeric format
        X.subject <-
                read.csv(
                        "./UCI_HAR_Dataset/UCI_HAR_Dataset/train/subject_train.txt",
                        sep = "",
                        header = F,
                        colClasses = "numeric",
                        stringsAsFactors = FALSE
                )   
        colnames(X.subject) <- c("Subject.ID")
        
        # Reading the features file in a character format
        df.features <-
                read.csv(
                        "./UCI_HAR_Dataset/UCI_HAR_Dataset/features.txt",
                        sep = "",
                        header = F,
                        colClasses = "character",
                        stringsAsFactors = FALSE
                )
        
        # Extracting the first column and transposing it
        # Using the select from the DPLYR package
        df.column.headers <- t(select(df.features, V2))
        
        # Read the X-Train file - read all columns as numeric
        X_Train <-
                read.csv(
                        "./UCI_HAR_Dataset/UCI_HAR_Dataset/train/X_train.txt",
                        sep = "",
                        header = FALSE,
                        colClasses = "numeric",
                        stringsAsFactors = FALSE
                )
        
        #Now applying the column names to the X_Train file
        colnames(X_Train) <- as.character(df.column.headers)
        
        # Creating a row number for each of the records in the file using a sequence so that it can be joined with the y file
        RowSeq <- seq(1, nrow(X_Train))
        RowSeq.header <- as.data.frame(RowSeq)
        rm(RowSeq)
        
        # doing a simple data frame concatenation
        X_Train_final <- data.frame(RowSeq.header, X_Train)

        # Read the Y-Train file
        Y_Train <-
                read.csv(
                        "./UCI_HAR_Dataset/UCI_HAR_Dataset/train/y_train.txt",
                        sep = "",
                        header = FALSE,
                        colClasses = "numeric",
                        stringsAsFactors = FALSE
                )
        
        # Using the mutate function to add a unique row ID called RowSeq to each row 
        Y_Train.1 <- dplyr::mutate(Y_Train, RowSeq = row_number(), FileType = "Train") %>% select(FileType, Activity.Id = V1, RowSeq)
        
        # Reading the activity labels
        activity.labels <-
                read.csv(
                        "./UCI_HAR_Dataset/UCI_HAR_Dataset/activity_labels.txt",
                        sep = "",
                        header = F,
                        stringsAsFactors = FALSE
                )       
        
        # Renaming the columns so that the join can be made - using the dplyr package
        activity.labels.1 <- dplyr::select(activity.labels, Activity.Id = as.numeric(V1), Activity.description = V2)
        
        # Making a left join Y_Train.1 and activity.labels.1 based on Activity.Id
        combined.activity.ds <- left_join(Y_Train.1, activity.labels.1)

        # Adding the subject ID
        combined.activity.ds <- data.frame(X.subject, combined.activity.ds) 

        #The Y file now has the activity description along with the row number and can now be joined with the x file
        
        # Now doing an inner join between the combined activity and train.X file
        # This file has the final dataset which includes all columns including feaures and subject along with other ID columns
        #       such as RowSeq (added to make verification simple) and FileType
        X.ds <- inner_join(combined.activity.ds,X_Train_final)
       
        # Selecting the dimension columns - this will then be used to drive the filtered columns
        X.Dim.Columns <- select(X.ds, FileType, RowSeq, Subject.ID, Activity.Id, Activity.description)
        
        # Now filtering for mean and std columns
        X.filtered.ds.tmp <- X.ds[ , grepl( "mean|std" , names( X.ds ) ) ]
        
        # Using the filtered DS to remove meanfreq
        X.filtered.ds <- X.filtered.ds.tmp[ , !grepl( "meanFreq" , names( X.filtered.ds.tmp ) ) ]
        rm(X.filtered.ds.tmp)
        
        # Uncomment the following line to keep the unfiltered dataset
        rm(X.ds)

        # Now joining back the dimensions with the filtered column to form the filtered Train data set
        Train.ds <- data.frame(X.Dim.Columns, X.filtered.ds)
        write.csv(Train.ds, "Final_Train.csv", row.names = FALSE)

        ###########################################################
        #
        # Now doing the same for the test dataset
        #
        ###########################################################
        
        # Reading the subject Test file in a numeric format
        Test.subject <-
                read.csv(
                        "./UCI_HAR_Dataset/UCI_HAR_Dataset/Test/subject_test.txt",
                        sep = "",
                        header = F,
                        colClasses = "numeric",
                        stringsAsFactors = FALSE
                )   
        colnames(Test.subject) <- c("Subject.ID")

        # Read the X-Test file - read all columns as numeric
        X_Test <-
                read.csv(
                        "./UCI_HAR_Dataset/UCI_HAR_Dataset/Test/X_test.txt",
                        sep = "",
                        header = FALSE,
                        colClasses = "numeric",
                        stringsAsFactors = FALSE
                )
        
        #Now applying the column names to the X_Test file
        colnames(X_Test) <- as.character(df.column.headers)

        # Creating a row number for each of the records in the file using a sequence so that it can be joined with the y file
        RowSeq <- seq(1, nrow(X_Test))
        RowSeq.header <- as.data.frame(RowSeq)        
        # doing a simple data frame concatenation
        X_Test_final <- data.frame(RowSeq.header, X_Test)

        # Read the Y-Test file
        Y_Test <-
                read.csv(
                        "./UCI_HAR_Dataset/UCI_HAR_Dataset/Test/y_Test.txt",
                        sep = "",
                        header = FALSE,
                        colClasses = "numeric",
                        stringsAsFactors = FALSE
                )
        
        # Using the mutate function to add a unique row ID called RowSeq.Test to each row 
        Y_Test.1 <- dplyr::mutate(Y_Test, RowSeq = row_number(), FileType = "Test") %>% select(FileType, Activity.Id = V1, RowSeq)
        
        # Making a left join Y_Test.1 and activity.labels.1 based on Activity.Id
        combined.activity.ds.test <- left_join(Y_Test.1, activity.labels.1)
        
        # Adding the subject ID
        combined.activity.ds.test <- data.frame(Test.subject, combined.activity.ds.test) 

        #The Y file now has the activity description along with the row number and can now be joined with the x file
        
        # Now doing an inner join between the combined activity and Test.X file
        # This file has the final dataset which includes all columns including feaures and subject along with other ID columns
        #       such as RowSeq (added to make verification simple) and FileType
        X.Test.ds <- inner_join(combined.activity.ds.test,X_Test_final)

        # Selecting the dimension columns - this will then be used to drive the filtered columns
        X.Dim.Columns <- select(X.Test.ds, FileType, RowSeq, Subject.ID, Activity.Id, Activity.description)
        
        # Now filtering for mean and std columns
        X.filtered.ds.tmp <- X.Test.ds[ , grepl( "mean|std" , names( X.Test.ds ) ) ]
        
        # Using the filtered DS to remove meanfreq
        X.filtered.ds <- X.filtered.ds.tmp[ , !grepl( "meanFreq" , names( X.filtered.ds.tmp ) ) ]
        rm(X.filtered.ds.tmp)
        rm(Y_Train.1)
        rm(activity.labels.1)
        rm(RowSeq.header)        

        # Now joining back the dimensions with the filtered column to form the filtered Test data set
        Test.ds <- data.frame(X.Dim.Columns, X.filtered.ds)
        write.csv(Test.ds, "Final_Test.csv", row.names = FALSE)

        # Now that the Test and Train datasets are created - merge them using rbind
        final.unclean.ds <- rbind(Train.ds[,-c(1:2)], Test.ds[,-c(1:2)])
        write.csv(final.unclean.ds, "unclean_ds.csv", row.names = FALSE)
        
        #Now cleaning up the variable names in the file
        colnames(final.unclean.ds) <- str_replace_all(colnames(final.unclean.ds),"^t","TDS.");colnames(final.unclean.ds) <- str_replace_all(colnames(final.unclean.ds),"^f","FDS.");colnames(final.unclean.ds) <- str_replace_all(colnames(final.unclean.ds),"\\.\\.\\.","\\.")
        colnames(final.unclean.ds) <- str_replace_all(colnames(final.unclean.ds),"\\.\\.","")  
        write.csv(final.unclean.ds, "clean_ds.csv", row.names = FALSE)
        
        # Now doing step 5 - i.e. group by Subject.ID and Activity.description
        # First doing a group by using dplyr package
        step5.agg.ds.1 <- group_by(final.unclean.ds, Subject.ID, Activity.description) %>% summarise_each(funs(mean))
        write.table(step5.agg.ds.1, "tidydata.txt", row.names = FALSE)
}
