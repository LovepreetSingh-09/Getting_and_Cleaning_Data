library(tidyverse)

X_train <- as_tibble(read.table('UCI HAR Dataset/train/X_train.txt'))
dim(X_train)
X_train
y_train <- as_tibble(read.table('UCI HAR Dataset/train/y_train.txt'))
dim(y_train)
y_train
sub_train <- as_tibble(read.table('UCI HAR Dataset/train/subject_train.txt'))
dim(sub_train)
sub_train

X_test <- as_tibble(read.table('UCI HAR Dataset/test/X_test.txt'))
dim(X_test)
y_test <- as_tibble(read.table('UCI HAR Dataset/test/y_test.txt'))
dim(y_test)
sub_test <- as_tibble(read.table('UCI HAR Dataset/test/subject_test.txt'))
dim(sub_test)

labels <- as_tibble(read.table('UCI HAR Dataset/activity_labels.txt'))
labels
features <- as_tibble(read.table('UCI HAR Dataset/features.txt'))
features

y_train <- merge(y_train, labels, by='V1')
str(y_train)
unique(y_train$V2)
y_test <- merge(y_test, labels, by='V1')
str(y_test)

names(X_train) <- features$V2
X_train
names(X_test) <- features$V2
X_test

Subject <- rbind(sub_train, sub_test)

X <- rbind(X_train, X_test)

feat <- names(X)
n_feat <- feat[grep(pattern = '(mean)|(std)', feat)]
length(n_feat)
n_feat
X = X[, n_feat]

Y = rbind(y_train, y_test)
Y

X <- cbind(X, Subject)
X$Activity <- Y$V2

names(X)<-gsub("Acc", "Accelerometer", names(X))
names(X)<-gsub("Gyro", "Gyroscope", names(X))
names(X)<-gsub("BodyBody", "Body", names(X))
names(X)<-gsub("Mag", "Magnitude", names(X))
names(X)<-gsub("^t", "Time", names(X))
names(X)<-gsub("^f", "Frequency", names(X))
names(X)<-gsub("tBody", "TimeBody", names(X))
names(X)<-gsub("-mean()", "Mean", names(X), ignore.case = TRUE)
names(X)<-gsub("-std()", "STD", names(X), ignore.case = TRUE)
names(X)<-gsub("-freq()", "Frequency", names(X), ignore.case = TRUE)
names(X)<-gsub("angle", "Angle", names(X))
names(X)<-gsub("gravity", "Gravity", names(X))
names(X) <- c(n_feat, 'subject', 'Activity')
names(X)

X <- as_tibble(X)
X

Final_X <- X %>%
  group_by(subject, Activity) %>%
  summarise_all(funs(mean))

Final_X

str(Final_X)

write.table(Final_X, 'Final_Data.txt', row.names = F)
