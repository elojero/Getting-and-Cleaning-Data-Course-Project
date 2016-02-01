
#TEST TABLE
#Labels
labels<-read.table("~/PROJECT WEEK4/activity_labels.txt", quote="\"", comment.char="")
colnames(labels)<-c("activity_id","activity")

#TESTS
#subject_test
subject_tests<- read.table("~/PROJECT WEEK4/test/subject_test.txt", quote="\"", comment.char="")
colnames(subject_tests)[1] <- "subject"
#subject_test type
subject_tests$subject_type<-"test"
#XTEST
xtest<- read.table("~/PROJECT WEEK4/test/X_test.txt", quote="\"", comment.char="")
varnames<-read.table("~/PROJECT WEEK4/features.txt", quote="\"", comment.char="")
colnames(xtest) <- varnames[,2]
#YTEST
    ytest<- read.table("~/PROJECT WEEK4/test/Y_test.txt", quote="\"", comment.char="")
    colnames(ytest)[1]<-"activity_id"
    ytest<-merge(ytest,labels,by.x="activity_id", by.y="activity_id")
    ytest<-as.data.frame(ytest$activity)
    colnames(ytest)[1]<-"activity"

data_test<-cbind(subject_tests, ytest, xtest)

#TEST TABLE---------------------------------------------------------------------------------------

#TRAIN
#subject_train
subject_train<- read.table("~/PROJECT WEEK4/train/subject_train.txt", quote="\"", comment.char="")
colnames(subject_train)[1] <- "subject"
#subject type
subject_train$subject_type<-"train"
#XTRAIN
xtrain<- read.table("~/PROJECT WEEK4/train/X_train.txt", quote="\"", comment.char="")
colnames(xtrain) <- varnames[,2]
#YTRAIN
ytrain<- read.table("~/PROJECT WEEK4/train/y_train.txt", quote="\"", comment.char="")
colnames(ytrain)[1]<-"activity_id"
ytrain<-merge(ytrain,labels,by.x="activity_id", by.y="activity_id")
ytrain<-as.data.frame(ytrain$activity)
colnames(ytrain)[1]<-"activity"

data_train<-cbind(subject_train, ytrain, xtrain)

#--bind train and tests tables
complete_data<-rbind(data_test,data_train)

meansvar<-grep("mean",varnames[,2])
meansvar<-as.vector(varnames[meansvar,2])
stdvar<-grep("std",varnames[,2])
stdvar<-as.vector(varnames[stdvar,2])
varlists<-c("subject","subject_type","activity",meansvar,stdvar)

#filtered variables (means and stdvs)
data_filtered<-complete_data[,varlists]
subset_filtered<-data_filtered[,c(1,3:82)]
subset_summary<-aggregate(subset_filtered, by = list(subset_filtered$subject, subset_filtered$activity), FUN = "mean")
subset_summary<-subset_summary[,c(-3,-4)]
colnames(subset_summary)[1:2]<-c("subject","activity")
write.table(subset_summary,"summary_table.txt")
