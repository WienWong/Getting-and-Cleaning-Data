
library(reshape2)
setwd("D:/Coursera_R/GC_Proj")

## Read features
features  <- read.table('features.txt')[, 2] 
features

ft        <- grepl("std | mean", features) # grepl returns TRUE if a string contains the pattern, otherwise FALSE; 
ft

activities<- read.table('activity_labels.txt',col.names = c('Code', 'ActivityName'))
activities

## Load data from test
xtest     <- read.table("test/X_test.txt", col.names = features)[, ft]
ytest     <- read.table("test/y_test.txt", col.names = c('Activity'))
subjtest  <- read.table("test/subject_test.txt", col.names = c('Subject'))

## Load data from train
xtrain    <- read.table("train/X_train.txt", col.names = features)[, ft]
ytrain    <- read.table("train/y_train.txt", col.names = c('Activity'))
subjtrain <- read.table("train/subject_train.txt", col.names = c('Subject'))

## Merge test and data sets
xys       <- cbind(rbind(ytest, ytrain), rbind(subjtest, subjtrain), rbind(xtest, xtrain))
xys       <- merge(x = xys, y = activities, by.x = 'Activity', by.y = 'Code', all = TRUE)[, -1]

## Create tidy dataset
meltDt    <- melt(xys, id.vars = c("Subject", 'ActivityName'))
tidyDt    <- dcast(meltDt, Subject + ActivityName ~ variable, mean)

# write tiny dataset
write.table(tidyDt, file = "TidyData.txt", row.names = FALSE, quote = FALSE)
write.table(tidyDt, file = "TidyData.csv", row.names = FALSE, quote = FALSE)
