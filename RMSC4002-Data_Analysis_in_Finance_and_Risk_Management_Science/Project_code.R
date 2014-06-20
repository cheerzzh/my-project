
##################
###Outlier detection####
##################

library("ggplot2")
d=read.csv("Concrete_Data.csv")           #read in the dataset

#divide the groups according to the variables controlled
#there are totally 8 groups possible

d0<-d[(d$Blast_Furnace_Slag==0)&(d$Fly_Ash==0)&(d$Superplasticizer==0),]	#without the three component
d1<-d[(d$Blast_Furnace_Slag!=0)&(d$Fly_Ash==0)&(d$Superplasticizer==0),]	#with one component
d2<-d[(d$Blast_Furnace_Slag==0)&(d$Fly_Ash!=0)&(d$Superplasticizer==0),]	#with one component
d3<-d[(d$Blast_Furnace_Slag==0)&(d$Fly_Ash==0)&(d$Superplasticizer!=0),]	#with one component
d4<-d[(d$Blast_Furnace_Slag!=0)&(d$Fly_Ash!=0)&(d$Superplasticizer==0),]	#with two components
d5<-d[(d$Blast_Furnace_Slag!=0)&(d$Fly_Ash==0)&(d$Superplasticizer!=0),]	#with two components
d6<-d[(d$Blast_Furnace_Slag==0)&(d$Fly_Ash!=0)&(d$Superplasticizer!=0),]	#with two components
d7<-d[(d$Blast_Furnace_Slag!=0)&(d$Fly_Ash!=0)&(d$Superplasticizer!=0),]	#with all three components

#define mahalanobis function to compute the distance

mdist<-function(x){
	t=as.matrix(x)
	m=apply(t,2,mean)
	s=var(t)
	mahalanobis(t,m,s)
}

#according to group numbers, only 5 groups needed outlier detection

id0<-c(1,4,6,7,8)										#define the id of columns needed (some columns are zero)
x0<-d0[,id0]											#get the columns from d0
md0<-data.frame(mdist(x0))								#compute mdist
number<-1:length(md0[,1])
md0<-cbind(number,md0)
ggplot(md0)+geom_point(aes(x=number,y=mdist.x0.,color=1))
c<-qchisq(0.99,df=5)									#p=5, type-I error=0.01
dc0<-d0[md0[,2]<c,]											#select cases from d0 with md0 < c
dim(d0)-dim(dc0)										#display the number of observations threw away

#the following four sections followed the same process as the first section

id1<-c(1,2,4,6,7,8)										#delet outliers in d1
x1<-d1[,id1]
md1<-data.frame(mdist(x1))  
number<-1:length(md1[,1])
md1<-cbind(number,md1)
ggplot(md1)+geom_point(aes(x=number,y=mdist.x1.,color=1))
c1<-qchisq(0.99,df=6)
dc1<-d1[md1[,2]<c1,]
dim(d1)-dim(dc1)

id5<-c(1,2,4,5,6,7,8)									#delet outliers in d5
x5<-d5[,id5]
md5<-data.frame(mdist(x5))  
number<-1:length(md5[,1])
md5<-cbind(number,md5)
ggplot(md5)+geom_point(aes(x=number,y=mdist.x5.,color=1))
c5<-qchisq(0.99,df=7)
dc5<-d5[md5[,2]<c5,]
dim(d5)-dim(dc5)

id6<-c(1,3,4,5,6,7,8)									#delet outliers in d6
x6<-d6[,id6]
md6<-data.frame(mdist(x6))  
number<-1:length(md6[,1])
md6<-cbind(number,md6)
ggplot(md6)+geom_point(aes(x=number,y=mdist.x6.,color=1))
c6<-qchisq(0.99,df=7)
dc6<-d6[md6[,2]<c6,]
dim(d6)-dim(dc6)

x7<-d7[,1:8]											#delet outliers in d7
md7<-data.frame(mdist(x7))  
number<-1:length(md7[,1])
md7<-cbind(number,md7)
ggplot(md7)+geom_point(aes(x=number,y=mdist.x7.,color=1))
c7<-qchisq(0.99,df=8)
dc7<-d7[md7[,2]<c7,]
dim(d7)-dim(dc7)

dc=rbind(dc0,dc1,d2,d3,d4,dc5,dc6,dc7)					#combine the cleaned data
write.csv(dc,file="Concrete_data1.csv",row.names=F)		#save the cleaned dataset to "Concrete_data1.csv"


##################
###PCA Analysis###
##################

d<-read.csv("Concrete_data1.csv")						#read new dataset after outlier deletion

pca<-princomp(d[,1:7],cor=T)							#perform PCA using correlation matrix
s<-pca$sdev												#save the sd of all PC to s
round(s^2,4)											#display variance
t=sum(s^2)												#computer total variance
round(s^2/t,4)											#proportion of variance explained by each PC
cumsum(s^2/t)											#cumulative sum of proportion of variance

variance<-pca$sdev^2									#plot the variance
variance<-data.frame(variance)
variance<-cbind(1:7,variance)
colnames(variance)<-c("comp","variance")
ggplot(variance)+geom_line(aes(x=comp,y=variance))
score<-pca$scores[,1:5]									#save the scores of PC1, PC2, PC3, PC4 and PC5
pairs(score)											#scatterplot of scores

pca$loadings[,1:5]										#display the loadings of the first five PCs
loading<-data.frame(cbind(1:7,pca$loadings[,1:5]))		#save the loading of each PC
colnames(loading)[1]<-"number"
ggplot(loading)+geom_line(aes(x=number,y=Comp.1))
ggplot(loading)+geom_line(aes(x=number,y=Comp.2))
ggplot(loading)+geom_line(aes(x=number,y=Comp.3))
ggplot(loading)+geom_line(aes(x=number,y=Comp.4))
ggplot(loading)+geom_line(aes(x=number,y=Comp.5))

#########################
###Classification Tree###
#########################

library(rpart)													#install package needed

#plot prediction against observation using continuous response

d<-read.csv("Concrete_data1.csv") 							 	#read data
ctree0<-rpart(Concrete_compressive_strength~.,data=d,cp=0.03)	#run continuous ctree
pr0<-cbind(predict(ctree0),d[,"Concrete_compressive_strength"])	#make prediction
colnames(pr0)<-c("prediction","observation")
pr0<-data.frame(pr0)
ggplot(pr0)+geom_point(											#plot prediction+geom_abline(color="dark blue")
	aes(x=prediction,y=observation,color=prediction))	

#draw the histogram of concrete strength

d<-read.csv("Concrete_data1.csv")								#read data
ggplot(d)+geom_histogram(										#plot histogram for concrete strength
	aes(Concrete_compressive_strength),
	fill="orange",color="black")

sam<-sample(1:1005,size=700)									#select training data

#Convert strength into categorical data
l1<-(d[,"Concrete_compressive_strength"]<=15)+0
l2<-(d[,"Concrete_compressive_strength"]>15&d[,"Concrete_compressive_strength"]<=32)+0
l3<-(d[,"Concrete_compressive_strength"]>32&d[,"Concrete_compressive_strength"]<=54)+0
l4<-(d[,"Concrete_compressive_strength"]>54)+0
l1<-l1+l2*2
l1<-l1+l3*3
l1<-l1+l4*4
Strength_Level<-as.factor(l1)
d<-cbind(d,Strength_Level)
d<-d[,-9]														#remove dummuy variables for ages of concrete

#run classification tree
train<-d[sam,]													#separate training and testing data
test<-d[-sam,]
ctree<-rpart(Strength_Level~.,data=train,cp=0.03)				#run ctree
pr<-predict(ctree,test)											#make predictiong based on testing data
pr<-max.col(pr)													#determing the class
table(pr,test[,9])												#compare prediction results and true response
plot(ctree)														#plot ctree
text(ctree,cex=0.7,use.n=T)

###########
### ANN ###
###########

#construct target table for logistic output in nueral network

l1<-(d[,"Concrete_compressive_strength"]<=15)+0
l2<-(d[,"Concrete_compressive_strength"]>15&d[,"Concrete_compressive_strength"]<=32)+0
l3<-(d[,"Concrete_compressive_strength"]>32&d[,"Concrete_compressive_strength"]<=54)+0
l4<-(d[,"Concrete_compressive_strength"]>54)+0
l1<-l1+l2*2
l1<-l1+l3*3
l1<-l1+l4*4
Strength_Level<-as.factor(l1)
d<-cbind(d,Strength_Level)
d<-d[,-9]		
num_class = 4
target<-matrix(c(rep(0,nrow(d)*num_class)),nrow=nrow(d),ncol=num_class)

for(i in 1:nrow(d)){
  target[i,d[i,9]]<-1
}

temp<-data.frame(apply(d[,c(1:8)],MARGIN=2,FUN=function(X)
	(X-min(X))/diff(range(X))))
temp<-cbind(temp,d[,9])

library(nnet)
set.seed(12345)

id<-sample(1:nrow(d),size=round(nrow(d)*0.8),replace = F)	#randomly choose testing data and training data
trainset<-temp[id,-9]
trainresp<-target[id,]

ann<-function(x,y,size,maxit=500,							#function to implememt nnet() multiple time to get best fit
	linout=F,try=100,decay=0,rang=0.0001){
	ann1<-nnet(y~.,data=x,size=size,maxit=maxit,
		linout=linout,decay=0,rang=0.0001)
	v1<-ann1$value
	for(i in 2:try){
		ann<-nnet(y~.,data=x,size=size,maxit=maxit,
			linout=linout,decay=0,rang=0.0001)
		if(ann$value<v1){
		v1<-ann$value
		ann1<-ann
		}
	}
	ann1
}

choose_size<-function(x,y,data_set,id,min_size=1,					#function to help in choosing the hidden layer size
	max_size=20,try=5,maxit=500,linout=F,decay=0,rang=0.0001){
	train_error<-vector()
	test_error<-vector()
	for(i in min_size:max_size){
		ann_fit<-ann(trainset,trainresp,try=try,
			size=i,maxit=maxit,decay=decay,rang=rang)				#call ann() function 
		train_re<-sum(ifelse(
			max.col(ann_fit$fit)==data_set[id,9],0,1))/length(id)
		test_re<-sum(ifelse(
			max.col(predict(ann_fit,data_set[-id,-9]))==
			data_set[-id,9],0,1))/nrow(data_set[-id,-9])
		train_error<-c(train_error,train_re)
		test_error<-c(test_error,test_re)
	}
	require(reshape)
	data<-data.frame(size=rep(min_size:max_size),
		training_error_rate=train_error,
		test_error_rate=test_error)
	Error_rate<-melt(data, id.vars = "size")
	ggplot(Error_rate,aes(x=size,y=value,colour=variable))+ 		#plot the training and test error
		geom_line()+xlab("Size of hidden layer")+
		ylab("Error rate")+
		ylim(min(train_error)-0.01,max(test_error)+0.02)			#get the appropriate hidden layer size
}


#it's quite computational intensive, may require a very long time to finish

set.seed(123)
choose_size(trainset,trainresp,temp,
	id,min_size=1,try=50,max_size=16,maxit=500)
chosen_size<-5
set.seed(123)
final_ann<-ann(trainset,trainresp,try=300,							#use ann() to get best fit ann model
	size=chosen_size,maxit=450)
summary(final_ann)

p<-max.col(final_ann$fit)
table(p,d[id,9])													#test training result
train_error_rate<-sum(ifelse(p==d[id,9],0,1))/length(id)

p1<-max.col(predict(final_ann,temp[-id,]))
table(p1,d[-id,9])													#testing error
test_error_rate<-sum(ifelse(p1 == temp[-id,9],0,1))/length(p1)

#############################################
###Dummy Variable and Multinomial Analysis###
#############################################

d<-read.csv("Concrete_Data.csv")
ggplot(d)+geom_point(
	aes(x=Age,y=Concrete_compressive_strength,color=Age)) 			#Plot 1 in dummy variable analysis
d1<-d[,c("Age","Concrete_compressive_strength")]
d1[d1$Age<=3&d1$Age>=1,1]<-1
d1[d1$Age<=14&d1$Age>=7,1]<-2
d1[d1$Age==28,1]<-3
d1[d1$Age==56,1]<-4
d1[d1$Age<=120&d1$Age>=90,1]<-5
d1[d1$Age>=180,1]<-6
ggplot(d1)+geom_boxplot(
	aes(factor(Age),Concrete_compressive_strength,fill="1"))		#Plot 2 in dummy variable analysis
fit<-lm(Concrete_compressive_strength~.,d)
summary(fit)														#Data for Table 1
d1<-read.csv("Concrete_data2.csv")
fit1<-lm(Concrete_compressive_strength~.-Age_S-Age,d1)
summary(fit1)														#Data for Table 1

l1<-(d[,"Concrete_compressive_strength"]<=15)+0
l2<-(d[,"Concrete_compressive_strength"]>15 & d[,"Concrete_compressive_strength"]<=32)+0
l3<-(d[,"Concrete_compressive_strength"]>32 & d[,"Concrete_compressive_strength"]<=54)+0
l4<-(d[,"Concrete_compressive_strength"]>54)+0
l1<-l1+l2*2+l3*3+l4*4
Concrete_compressive_strength<-as.factor(l1)
d<-cbind(d,Concrete_compressive_strength)
d<-d[,-9]
sam<-sample(1:1005,700)
d_train<-d[sam,]
d_test<-d[-sam,]
mnl<-multinom(Concrete_compressive_strength~.,d_train)
summary(mnl)														#mnl output
pred<-predict(mnl)
table(pred,d_train$Concrete_compressive_strength)
Error<-1-sum(diag(table(pred,d_train$Concrete_compressive_strength)))/nrow(d_train)
Error																#Training Error
pred1<-predict(mnl,d_test)
table(pred1,d_test$Concrete_compressive_strength)
Error1<-1-sum(diag(table(pred1,d_test$Concrete_compressive_strength)))/nrow(d_test)
Error1																#Testing Error

