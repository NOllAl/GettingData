#Download and unzip data
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists("data")){dir.create("data")}
curdir <- getwd()
setwd(paste(curdir,"/data/",sep=""))
download.file(url,destfile="data.zip")
unzip("data.zip")
setwd(curdir)

#Load data and merge training with test data
test_data <- read.table(paste(curdir,"/data/UCI HAR Dataset/test/X_test.txt",sep=""))
test_data_act <- read.table(paste(curdir,"/data/UCI HAR Dataset/test/Y_test.txt",sep=""))
test_data <- cbind(test_data_act,test_data)
train_data <- read.table(paste(curdir,"/data/UCI HAR Dataset/train/X_train.txt",sep=""))
train_data_act <- read.table(paste(curdir,"/data/UCI HAR Dataset/train/Y_train.txt",sep=""))
train_data <- cbind(train_data_act,train_data)
data1 <- rbind(test_data,train_data)

varnames <- readLines(paste(curdir,"/data/UCI HAR Dataset/features.txt",sep="")) #Get variable names
ind <- grep("mean\\(|std",varnames) + 1    #get indices containing mean and sd measurement (and add one, because we added the activity line)
ind <- c(1, ind)                #add activity label
data <- data1[,ind]             #select data measurement with mean and standard variables

#Change variable names to something descriptive
varnames <- varnames[ind-1]
varnames <- (gsub("[0-9]+ ","",varnames))  #get rid of numbers in front
varnames <- gsub("-mean\\(\\)","Mean",varnames) #get rid of dash and () in mean
varnames <- gsub("-std\\(\\)","Std",varnames)
varnames <- c("Activity",varnames)
names(data) <- varnames
data$Activity <- factor(data$Activity,level=1:6,labels=c("Walk","Walk_Up","Walk_Down","Sit","Stand","Lay"))

#Create the seconde data second required in the assignment
data_sum <- aggregate(data[,2:dim(data)[2]],list(Acttivity=data$Activity),mean)

#Write mean data to txt file
write.table(data_sum,file="data_sum.txt",row.name=FALSE)