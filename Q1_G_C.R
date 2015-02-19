
# Getting and Cleaning Data
# Week 1 Quiz 1

# Q1 How many properties are worth $1,000,000 or more?

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"

download.file(fileUrl, destfile = "D:/Coursera_R/GetAndClean/housing.csv")

dateDownloaded <- date()
dateDownloaded
# "Thu Feb 19 14:30:41 2015"

getwd()

direct <- paste(getwd(), "/GetAndClean", sep = "", collapse = NULL)

setwd(direct)

getwd()

house <- read.csv("housing.csv")

# Code book says VAL of 24 represents any house more than $1,000,000. 
housPro <- house[!is.na(house$VAL) & house$VAL == 24, ]

nrow(housPro)

# Q2 

# FES has'Family type and employment status' as described in codebook
table(house$FES)

summary(house$FES)

# Tidy data has one variable per column.

# Q3 Read rows 18-23 and columns 7-15 into R and assign the result to a variable called: dat # What is the value of: sum
# (datZip*datExt,na.rm=T)

fileUrl1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"

direct2 <- paste(direct, "/gov_NGAP.xlsx", sep = "", collapse = NULL)
direct2

download.file(url=fileUrl1, destfile=direct2, mode="wb")

library(xlsx)

# rowIndex <- 18:23
colIndx <- 7:15
dat <- read.xlsx2(direct2, sheetIndex = 1, startRow = 18, endRow = 23, colIndex = colIndx, header = TRUE)

head(dat)
#     Zip CuCurrent PaCurrent PoCurrent      Contact Ext     Fax email        Status
# 1 74136         0         1         0 918-491-6998   0 918-491-6659            1
# 2 30329         1         0         0 404-321-5711                             1
# 3 74136         1         0         0 918-523-2516   0 918-523-2522            1
# 4 80203         0         1         0 303-864-1919   0                         1
# 5 80120         1         0         0 345-098-8890 456                         1

class(dat)
# "data.frame"

sum(dat$Zip*dat$Ext,na.rm=T) 
# Warning message:
# In Ops.factor(dat$Zip, dat$Ext) : * not meaningful for factors

# Factor variable to numeric variable -- as.numeric(levels(f))[f]
zip_num <- as.numeric(levels(dat$Zip))[dat$Zip]
ext_num <- as.numeric(levels(dat$Ext))[dat$Ext]

sum(zip_num * ext_num, na.rm=TRUE) 
## [1] 36534720

# Below is an example for using 'openxlsx'

fileUrl <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.xlsx?accessType=DOWNLOAD"

direct3 <- paste(direct, "/cameras.xlsx", sep = "", collapse = NULL)
direct3

download.file(fileUrl, destfile=direct3, mode="wb")

# trying URL 'https://data.baltimorecity.gov/api/views/dz54-2aru/rows.xlsx?accessType=DOWNLOAD'
# Content type 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet; charset=utf-8' length 9923 bytes
# opened URL
# downloaded 9923 bytes

list.files(direct)
#  "cameras.xlsx"  "gov_NGAP.xlsx" "housing.csv"  

dateDownloaded <- date()
print(dateDownloaded)
# "Thu Feb 19 15:01:23 2015"

library(openxlsx)

# Attaching package: openxlsx
# The following objects are masked from package:xlsx:   
#    createWorkbook, loadWorkbook, read.xlsx, saveWorkbook, write.xlsx
# Warning message:
#    package openxlsx was built under R version 3.1.2 

cameraData <- read.xlsx(direct3)

head(cameraData)

# Q4 How many restaurants have zipcode 21231?

library(XML)

fileUrl <- "http://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"

doc <- xmlTreeParse(fileUrl,useInternal=TRUE)

rootNode <- xmlRoot(doc)

xmlName(rootNode)
# [1] "response"

rootNode[[1]]

rootNode[[1]][[1]]

xmlSApply(rootNode, xmlValue)

xpathSApply(rootNode, "//zipcode", xmlValue)

zpcd <- xpathSApply(rootNode, "//zipcode", xmlValue)

zpcd[zpcd == 21231]

length(zpcd[zpcd == 21231])
# 127

# Q5 Which of the following is the fastest way to calculate the average value of the variable  pwgtp15  broken down by sex
# using the data.table package?

myUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"

download.file(url=myUrl, destfile="commu.csv", mode="w", method="curl")

library(data.table)

DT <- fread(input="commu.csv", sep=",")
# 'commu.csv' is not recognized as an internal or external command,
# operable program or batch file.
# Error in fread(input = "commu.csv", sep = ",") : 
#     File is empty: C:\Users\Weihua\AppData\Local\Temp\RtmpG25hPO\file267058615cc7
#

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"

direct4 <- paste(direct, "/community.csv", sep = "", collapse = NULL)
direct4

download.file(fileUrl, destfile = direct4)

dateDownloaded <- date()
dateDownloaded
# "Thu Feb 19 15:13:28 2015"

DT <- read.csv("community.csv")

library(data.table)

DT <- fread(input = "community.csv", sep = ",")

# 
system.time(mean(DT$pwgtp15,by=DT$SEX))
# user  system elapsed 
# 0       0       0 

system.time(DT[,mean(pwgtp15),by=SEX])
# user  system elapsed 
# 0.02    0.00    0.11

system.time(tapply(DT$pwgtp15,DT$SEX,mean))
# user  system elapsed 
# 0.02    0.00    0.01 

# system.time(mean(DT[DT$SEX==1,]$pwgtp15)); mean(DT[DT$SEX==2,]$pwgtp15))

system.time(sapply(split(DT$pwgtp15,DT$SEX),mean))
# user  system elapsed 
# 0.01    0.00    0.02
