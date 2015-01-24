## Create one R script called run_analysis.R that does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Sys.setenv(JAVA_HOME='C:/Program Files/Java/jre1.8.0_25')

library(plyr)

download.data = function() {
 # "Checks for data directory and creates one if it doesn't exist"
 # if (!file.exists("data")) {
 #  message("Creating data directory")
  #  dir.create("data")
  #}
  #if (!file.exists("data/UCI HAR Dataset")) {
    # download the data
   # fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    #zipfile="data/UCI_HAR_data.zip"
    #message("Downloading data")
    #download.file(fileURL, destfile=zipfile, method="curl")
    #unzip(zipfile, exdir="data")
  #}
#}

if (!require("data.table")) {
  install.packages("data.table")
}

if (!require("reshape2")) {
  install.packages("reshape2")
}

require("data.table")
require("reshape2")

list.files("C:/Users/Admin/Documents/R/directoryR/Programming assignment-CleaningData/getdata-projectfiles-UCI HAR Dataset")
# Load: activity labels
activity_labels <- read.table("C:/Users/Admin/Documents/R/directoryR/Programming assignment-CleaningData/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")[,2]

# Load: data column names
features <- read.table("C:/Users/Admin/Documents/R/directoryR/Programming assignment-CleaningData/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt")[,2]

# Extract only the measurements on the mean and standard deviation for each measurement.
extract_features <- grepl("mean|std", features)

# Load and process X_test & y_test data.
X_test <- read.table("C:/Users/Admin/Documents/R/directoryR/Programming assignment-CleaningData/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("C:/Users/Admin/Documents/R/directoryR/Programming assignment-CleaningData/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("C:/Users/Admin/Documents/R/directoryR/Programming assignment-CleaningData/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")

names(X_test) = features

# Extract only the measurements on the mean and standard deviation for each measurement.
X_test = X_test[,extract_features]

# Load activity labels
y_test[,2] = activity_labels[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"

# Bind data
test_data <- cbind(as.data.table(subject_test), y_test, X_test)

# Load and process X_train & y_train data.
X_train <- read.table("C:/Users/Admin/Documents/R/directoryR/Programming assignment-CleaningData/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("C:/Users/Admin/Documents/R/directoryR/Programming assignment-CleaningData/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")

subject_train <- read.table("C:/Users/Admin/Documents/R/directoryR/Programming assignment-CleaningData/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")

names(X_train) = features

# Extract only the measurements on the mean and standard deviation for each measurement.
X_train = X_train[,extract_features]

# Load activity data
y_train[,2] = activity_labels[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

# Bind data
train_data <- cbind(as.data.table(subject_train), y_train, X_train)

# Merge test and train data
data = rbind(test_data, train_data)

id_labels   = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)
melt_data      = melt(data, id = id_labels, measure.vars = data_labels)

# Apply mean function to dataset using dcast function
tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean)

write.table(tidy_data, file = "C:/Users/Admin/Documents/R/directoryR/Programming assignment-CleaningData/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/tidy_data.txt")
