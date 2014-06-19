##=======================STAT4002=========================================##
##=======================Course Project===================================##
##=Wine Quality Analysis Utilizing Multivariate Statistical Techniques====##
##
## Group Members:
## Kong Yunchuan    1155014473
## PAN Shenyi       1155014429
## ZENG Qinghao     1155014454
## Zhou Zhihao      1155014412
##
##required packages:
## grid, ggplot2, reshape, MASS
##
##==========================================================##

##====================Data summary============================##
red = read.csv("winequality-red.csv")	#read in the raw data
white = read.csv("winequality-white.csv")

red = as.matrix(red)

white =  as.matrix(white)
meanred=apply(red,2,mean)	#compute sample mean
meanwhite=apply(white,2,mean)
maxred=apply(red,2,max)	#get the sample max value
maxwhite=apply(white,2,max)
minred=apply(red,2,min)	#get the sample min value
minwhite=apply(white,2,min)
sdred=apply(red,2,sd)	#compue the sample standard deviation
sdwhite=apply(white,2,sd)

#Test for the equality of covariance matrices:
p=ncol(red)-1
n1=nrow(red)
n2=nrow(white)
s1=cov(red[,-12])	#compute the sample covariance matrix of the first 11 attributes
s2=cov(white[,-12])
sp=((n1-1)*s1+(n2-1)*s2)/(n1+n2-2)	#compute sp matrix
n=n1+n2
M=(n-2)*log(det(sp))-(n1-1)*log(det(s1))-(n2-1)*log(det(s2))
u=(1/(n1-1)+1/(n2-1)-1/(n-2))*(2*p^2+3*p-1)/(6*(p+1))
chi=(1-u)*M	#test statistic
1-pchisq(chi,p*(p+1)/2)	#p-value

##===============================================================##

##=================================================================##
##======================density plot and box plot=================================#
# Multiple plot function
#
# ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
# - cols:   Number of columns in layout
# - layout: A matrix specifying the layout. If present, 'cols' is ignored.
#
# If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# then plot 1 will go in the upper left, 2 will go in the upper right, and
# 3 will go all the way across the bottom.
#
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  require(grid)
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}

red = read.csv("winequality-red.csv")
white = read.csv("winequality-white.csv")

#combine two data sets for plot
n_r = nrow(red)
n_w = nrow(white)

#library(plyr)
df = data.frame(cond =c(rep("red wine",n_r),rep("white wine",n_w)),rbind(red,white))
#cdf <- ddply(df,"cond", summarise, rating.mean=mean(rating)) #compute mean

# Density plots with semi-transparent fill
library(ggplot2)
name = names(df)
# "fixed.acidity"        "volatile.acidity"     "citric.acid"         
# "residual.sugar"       "chlorides"            "free.sulfur.dioxide"  "total.sulfur.dioxide"
#"density"              "pH"                   "sulphates"            "alcohol"             
# "quality"             


#density plot, store in ggplot objects
p1 = ggplot(df, aes(x=fixed.acidity, color=cond))+ geom_density(alpha=.3)
p2 = ggplot(df, aes(x=volatile.acidity, color=cond))+ geom_density(alpha=.3)
p3 = ggplot(df, aes(x=citric.acid, color=cond))+ geom_density(alpha=.3)
p4 = ggplot(df, aes(x=residual.sugar, color=cond))+ geom_density(alpha=.3)
p5 = ggplot(df, aes(x=chlorides, color=cond))+ geom_density(alpha=.3)
p6 = ggplot(df, aes(x=free.sulfur.dioxide, color=cond))+ geom_density(alpha=.3)
p7 = ggplot(df, aes(x=total.sulfur.dioxide, color=cond))+ geom_density(alpha=.3)
p8 = ggplot(df, aes(x=density, color=cond))+ geom_density(alpha=.3)
p9 = ggplot(df, aes(x=pH, color=cond))+ geom_density(alpha=.3)
p10 = ggplot(df, aes(x=sulphates, color=cond))+ geom_density(alpha=.3)
p11 = ggplot(df, aes(x=alcohol, color=cond))+ geom_density(alpha=.3)

multiplot(p1, p2, p3, p4,p5,p6, cols=2)
multiplot(p7, p8, p9, p10, p11,cols=2)
#use p1 to get plot of first attribute

#box plot, store in ggplot objects
m1 = ggplot(df, aes(x=cond, y=fixed.acidity, fill=cond))+ geom_boxplot()
m2 = ggplot(df, aes(x=cond, y=volatile.acidity, fill=cond))+ geom_boxplot()
m3 = ggplot(df, aes(x=cond, y=citric.acid, fill=cond))+ geom_boxplot()
m4 = ggplot(df, aes(x=cond, y=residual.sugar, fill=cond))+ geom_boxplot()
m5 = ggplot(df, aes(x=cond, y=chlorides, fill=cond))+ geom_boxplot()
m6 = ggplot(df, aes(x=cond, y=free.sulfur.dioxide, fill=cond))+ geom_boxplot()
m7 = ggplot(df, aes(x=cond, y=total.sulfur.dioxide, fill=cond))+ geom_boxplot()
m8 = ggplot(df, aes(x=cond, y=density, fill=cond))+ geom_boxplot()
m9 = ggplot(df, aes(x=cond, y=pH, fill=cond))+ geom_boxplot()
m10 = ggplot(df, aes(x=cond, y=sulphates, fill=cond))+ geom_boxplot()
m11 = ggplot(df, aes(x=cond, y=alcohol, fill=cond))+ geom_boxplot()

multiplot(m1, m2, m3, m4,m5,m6, cols=2)
multiplot(m7, m8, m9, m10, m11,cols=2)


##=================================================================##



##=================================================================##
##==================outline detection and normality test=============##
#outline detection by Mahalanobis distance 
red = read.csv("winequality-red.csv") 
white = read.csv("winequality-white.csv")
red = as.matrix(red)
white =  as.matrix(white)

#normality test

#outliner detection and deletion for red wine
d_r = red[,-12]
n= nrow(d_r)
p = ncol(d_r)
m<-apply(d_r,2,mean)
m<-matrix(m,nr=n,nc=p,byrow=T)
S<-var(d_r)
Sinv<-solve(S)
md<-diag((d_r-m)%*%Sinv%*%t(d_r-m))
d2 = sort(md)
i<-((1:n)-0.5)/n # create vector (i-0.5)/n
q<-qchisq(i,p) # obtain i-th percentile from chisq with p df 
qqplot(q,d2,main="QQ-Chisq for red wine") # plot d2 vs q
abline(lsfit(q,d2),col="red") # add a reference line
plot(md, main = "Mahalanobis distance for red wine")
c<-qchisq(0.99,df=p)
abline(h=c,col="red")
RedWine_c  =data.frame(red[md<c,]) #store cleaned data
dim(RedWine_c)
nrow(red) - nrow(RedWine_c) #number of outlier deleted
write.csv(RedWine_c,file="red_clean.csv",row.names=F)

#outlier detection and deletion for white wine
d_w = white[,-12]
n= nrow(d_w)
p = ncol(d_w)
m<-apply(d_w,2,mean)
m<-matrix(m,nr=n,nc=p,byrow=T)
S<-var(d_w)
Sinv<-solve(S)
md<-diag((d_w-m)%*%Sinv%*%t(d_w-m))
d2 = sort(md)
i<-((1:n)-0.5)/n # create vector (i-0.5)/n
q<-qchisq(i,p) # obtain i-th percentile from chisq with p df 
qqplot(q,d2,main="QQ-Chisq for white wine") # plot d2 vs q
abline(lsfit(q,d2),col="red") # add a reference line
plot(md,main = "Mahalanobis distance for white wine")
c<-qchisq(0.99,df=p)
abline(h=c,col="red")
WhiteWine_c<-data.frame(white[md<c,]) #store cleaned data
dim(WhiteWine_c) 
nrow(white) - nrow(WhiteWine_c) #number of outlier deleted
write.csv(WhiteWine_c,file="white_clean.csv",row.names=F)

##=================================================================##


##======================Principal component analysis======================##

#For White Wine
par(mfrow=c(1,2))
options(digits=3)
white<-read.csv("white_clean.csv")	# Load data white wine
w<-white[,1:11]	# Exclude the quality column
pcaw<-princomp(w)	# Perform PCA
pcaw$loadings	# Display loadings
summary(pcaw)	# Display variance
screeplot(pcaw,type="lines",ylim=c(0,2000),main="PCA Scree Plot of white wine",lwd=1.8)


#For Red Wine
red<-read.csv("red_clean.csv")
r<-red[,1:11]	#Exclude the quality column
pcar<-princomp(r)
pcar$loadings
summary(pcar)
screeplot(pcar,type="lines",ylim=c(0,1000),main="PCA Scree Plot of red wine",lwd=1.8)
par(mfrow=c(1,1))
##=======================================================================##

##=================================================================##
##=============================Discriminant Analysis====================================##

RedWine_c  = read.csv("red_clean.csv")
WhiteWine_c = read.csv("white_clean.csv")

#test common covariance in red and white separately
#Box’s M test for equality of covariance matrices

#for red wine
summary(as.factor(RedWine_c[,"quality"])) 
#3   4   5   6   7   8 
#7  46 640 599 187  18 
#choose 3,4,5 as low quality, 6,7,8 as high quality 
Red_high = RedWine_c[RedWine_c[,"quality"]>=6,-12]
Red_low = RedWine_c[RedWine_c[,"quality"]<6,-12]

p = ncol(Red_high)
n1= nrow(Red_high); n2 = nrow(Red_low)
S1 = cov(Red_high); S2= cov(Red_low)

Sp = ((n1-1)*S1+(n2-1)*S2)/(n1+n2-2)
M<-(n-2)*log(det(Sp))-(n1-1)*log(det(S1))-(n2-1)*log(det(S2))
u<-(1/(n1-1)+1/(n2-1)-1/(n-2))*(2*p^2+3*p-1)/(6*(p+1))
chi<-(1-u)*M
1-pchisq(chi,p*(p+1)/2) #p-value is 1, accept the null hpythoesis that covariance are equal for low and high quality red wine

#for white wine
summary(as.factor(WhiteWine_c[,"quality"])) 
#3    4    5    6    7    8    9    quality level
#10  140 1376 2116  863  168    5   counts
#choose 3,4,5 as low quality, 6,7,8 as high quality 
white_high = WhiteWine_c[WhiteWine_c[,"quality"]>=6,-12]
white_low = WhiteWine_c[WhiteWine_c[,"quality"]<6,-12]

p = ncol(white_high)
n1= nrow(white_high); n2 = nrow(white_low)
S1 = cov(white_high); S2= cov(white_low)

Sp = ((n1-1)*S1+(n2-1)*S2)/(n1+n2-2)
M<-(n-2)*log(det(Sp))-(n1-1)*log(det(S1))-(n2-1)*log(det(S2))
u<-(1/(n1-1)+1/(n2-1)-1/(n-2))*(2*p^2+3*p-1)/(6*(p+1))
chi<-(1-u)*M
1-pchisq(chi,p*(p+1)/2) #p-value is 1, accept the null hpythoesis that covariance are equal for low and high quality white wine


#apply LDA to two wine
library(MASS)
#for red wine without cross validation
qua_r = ifelse(RedWine_c[,"quality"]>=6,1,0)
RedWine_c[,"quality"] = qua_r
#n= nrow(RedWine_c)
#n1 = sum(qua_r)
lda_r<-lda(quality~.,data=RedWine_c) #use cross-validation + prior distribution?
pred_r<-predict(lda_r)$class
(t_r = table(pred_r,RedWine_c$quality)) #75.2%
sum(diag(prop.table(t_r))) #prediction accuracy for red wine

#view LDA for red wine
lda_r
#for white wine without cross-validation
qua_w = ifelse(WhiteWine_c[,"quality"]>=6,1,0)
WhiteWine_c[,"quality"] = qua_w
lda_w<-lda(quality~.,data=WhiteWine_c) #use cross-validation
pred_w<-predict(lda_w)$class
(t_w = table(pred_w,WhiteWine_c$quality) )#75%
sum(diag(prop.table(t_w))) #prediction accuracy for white wine 
#view lda for white
lda_w

#to better assess the prediction perform of linear discriminant function
#employ cross validation

#for red wine
lda_r<-lda(quality~.,data=RedWine_c,CV=T) #use cross-validation + prior distribution?
pred_r<-lda_r$class
(t_r = table(pred_r,RedWine_c$quality)) #75.2%
sum(diag(prop.table(t_r))) #prediction accuracy for red wine
#for white wine
lda_w<-lda(quality~.,data=WhiteWine_c,CV=T) #use cross-validation
pred_w<-lda_w$class
(t_w = table(pred_w,WhiteWine_c$quality) )#75%
sum(diag(prop.table(t_w))) #prediction accuracy for white wine


#canonical LDA
#for red wine
par(mfrow=c(1,2))
x = as.matrix(RedWine_c[,-12])
d0<-RedWine_c[RedWine_c[,12]==0,-12]  	# select HSI=0
d1<-RedWine_c[RedWine_c[,12]==1,-12]		# select HSI=1
n0<-nrow(d0)			# size for group 0
n1<-nrow(d1)			# size for group 1

s0<-var(d0)			# var for group 0 and 1
s1<-var(d1)
W<-(n0-1)*s0+(n1-1)*s1		# Within group SS
m0<-apply(d0,2,mean)		# mean for group 0
m1<-apply(d1,2,mean)		# mean for group 1
m<-apply(x,2,mean)		# overall mean
B<-n0*(m0-m)%*%t(m0-m)+n1*(m1-m)%*%t(m1-m)	# Between group SS
eig<-eigen(W)				# eigen for W
H<-eig$vector				# eigen vector
ev<-eig$value				# eiegn values
Wir<-H%*%diag(1/sqrt(ev))%*%t(H)	# sqrt of inv(W)
A<-Wir%*%B%*%Wir			# A = W^(-1/2) B W^(-1/2)
eig<-eigen(A)				# eigen of A
round(eig$values,3)			# display eigenvalues
(a<-eig$vectors[,1])			# save and display the first eigen-vetor to a
y<-x%*%Wir%*%a				# transform y=a'x
plot(y,RedWine_c[,12],pch=21,bg=c("red","blue")[RedWine_c[,12]+1],main = "Canonical Score Plot for red wine",ylab="True Class",xlab="Canonical score")	# plot y vs quality

ym<-by(y,RedWine_c[,12],colMeans)		# compute mean for group 0 and 1
yc<-(ym[1]+ym[2])/2			# compute mid-point of ym[1] and ym[2]
abline(v=ym[1])				# add ym and yc to the plot
abline(v=ym[2])
abline(v=yc)

pr1<-y>yc				# prediction
(c_r = table(pr1,RedWine_c[,12])	)	# classfication table
sum(diag(prop.table(c_r))) #prediction accuracy for red wine use canonical DA 

#for white wine
x = as.matrix(WhiteWine_c[,-12])
d0<-WhiteWine_c[WhiteWine_c[,12]==0,-12]  	# select HSI=0
d1<-WhiteWine_c[WhiteWine_c[,12]==1,-12]		# select HSI=1
n0<-nrow(d0)			# size for group 0
n1<-nrow(d1)			# size for group 1

s0<-var(d0)			# var for group 0 and 1
s1<-var(d1)
W<-(n0-1)*s0+(n1-1)*s1		# Within group SS
m0<-apply(d0,2,mean)		# mean for group 0
m1<-apply(d1,2,mean)		# mean for group 1
m<-apply(x,2,mean)		# overall mean
B<-n0*(m0-m)%*%t(m0-m)+n1*(m1-m)%*%t(m1-m)	# Between group SS
eig<-eigen(W)				# eigen for W
H<-eig$vector				# eigen vector
ev<-eig$value				# eiegn values
Wir<-H%*%diag(1/sqrt(ev))%*%t(H)	# sqrt of inv(W)
A<-Wir%*%B%*%Wir			# A = W^(-1/2) B W^(-1/2)
eig<-eigen(A)				# eigen of A
round(eig$values,3)			# display eigenvalues
(a<-eig$vectors[,1])			# save and display the first eigen-vetor to a
y<-x%*%Wir%*%a				# transform y=a'x
plot(y,WhiteWine_c[,12],pch=21,bg=c("red","blue")[WhiteWine_c[,12]+1],main = "Canonical Score Plot for white wine",ylab="True Class",xlab="Canonical score")	# plot y vs quality

ym<-by(y,WhiteWine_c[,12],colMeans)		# compute mean for group 0 and 1
yc<-(ym[1]+ym[2])/2			# compute mid-point of ym[1] and ym[2]
abline(v=ym[1])				# add ym and yc to the plot
abline(v=ym[2])
abline(v=yc)

pr2<-y>yc				# prediction
(c_w = table(pr2,WhiteWine_c[,12]))
sum(diag(prop.table(c_w))) #prediction accuracy for white wine use canonical DA 

##=================================================================##
##=============factor analysis==================================##
red=read.csv("red_clean.csv") # read in data

fa1.red<-factanal(red,factors=1,scores="regression") # save outputs from 1-factor to 7-factor
fa2.red<-factanal(red,factors=2,scores="regression") 
fa3.red<-factanal(red,factors=3,scores="regression")
fa4.red<-factanal(red,factors=4,scores="regression")
fa5.red<-factanal(red,factors=5,scores="regression")
fa6.red<-factanal(red,factors=6,scores="regression")
fa7.red<-factanal(red,factors=7,scores="regression")

fa1.red$PVAL # p-values
fa2.red$PVAL
fa3.red$PVAL
fa4.red$PVAL
fa5.red$PVAL
fa6.red$PVAL
fa7.red$PVAL

(L1.red<-fa1.red$loadings) # save and display factor loadings
(L2.red<-fa2.red$loadings)
(L3.red<-fa3.red$loadings)
(L4.red<-fa4.red$loadings)
(L5.red<-fa5.red$loadings)
(L6.red<-fa6.red$loadings)
(L7.red<-fa7.red$loadings)

(U1.red<-fa1.red$unique)  # save and display uniqueness
(U2.red<-fa2.red$unique) 
(U3.red<-fa3.red$unique) 
(U4.red<-fa4.red$unique) 
(U5.red<-fa5.red$unique)
(U6.red<-fa6.red$unique)
(U7.red<-fa7.red$unique)

apply(L1.red^2,1,sum) # communalities
apply(L2.red^2,1,sum)
apply(L3.red^2,1,sum)
apply(L4.red^2,1,sum)
apply(L5.red^2,1,sum)
apply(L6.red^2,1,sum)
apply(L7.red^2,1,sum)

white=read.csv("white_clean.csv") # read in data

fa1.white<-factanal(white,factors=1,scores="regression") # save outputs from 1-factor to 7-factor
fa2.white<-factanal(white,factors=2,scores="regression") 
fa3.white<-factanal(white,factors=3,scores="regression")
fa4.white<-factanal(white,factors=4,scores="regression")
fa5.white<-factanal(white,factors=5,scores="regression")
fa6.white<-factanal(white,factors=6,scores="regression")
fa7.white<-factanal(white,factors=7,scores="regression")

fa1.white$PVAL # p-values
fa2.white$PVAL
fa3.white$PVAL
fa4.white$PVAL
fa5.white$PVAL
fa6.white$PVAL
fa7.white$PVAL

(L1.white<-fa1.white$loadings) # save and display factor loadings 
(L2.white<-fa2.white$loadings)
(L3.white<-fa3.white$loadings)
(L4.white<-fa4.white$loadings)
(L5.white<-fa5.white$loadings)
(L6.white<-fa6.white$loadings)
(L7.white<-fa7.white$loadings)

(U1.white<-fa1.white$unique)  # save and display uniqueness
(U2.white<-fa2.white$unique) 
(U3.white<-fa3.white$unique) 
(U4.white<-fa4.white$unique) 
(U5.white<-fa5.white$unique)
(U6.white<-fa6.white$unique)
(U7.white<-fa7.white$unique)

apply(L1.white^2,1,sum) # communalities
apply(L2.white^2,1,sum)
apply(L3.white^2,1,sum)
apply(L4.white^2,1,sum)
apply(L5.white^2,1,sum)
apply(L6.white^2,1,sum)
apply(L7.white^2,1,sum)

##===================================================================##
##====================PCC=============================================##
red=read.csv("red_clean.csv") # read in the data
white=read.csv("white_clean.csv")
red.cor=cor(red) # correlation matrics
white.cor=cor(white)
red.s=cov(red) # covariance matrics
white.s=cov(white)
red.s11=red.s[c(4:5,7:12),c(4:5,7:12)] # partition the covariance matrics
red.s12=red.s[c(4:5,7:12),c(1:3,6)]
red.s21=red.s[c(1:3,6),c(4:5,7:12)]
red.s22=red.s[c(1:3,6),c(1:3,6)]
white.s11=white.s[c(4:5,7:12),c(4:5,7:12)] # partition the covariance matrics
white.s12=white.s[c(4:5,7:12),c(1:3,6)]
white.s21=white.s[c(1:3,6),c(4:5,7:12)]
white.s22=white.s[c(1:3,6),c(1:3,6)]
red.s11.2=red.s11-red.s12%*%solve(red.s22)%*%red.s21 # compute S11.2 of red 
white.s11.2=white.s11-white.s12%*%solve(white.s22)%*%white.s21
cov2cor(red.s11)  # compute correlation of S11 of red
cov2cor(red.s11.2) # compute correlation of S11.2 of red
cov2cor(red.s11)-cov2cor(red.s11.2) # the difference of the correlations of S11 & S11.2 of red
cov2cor(white.s11)  # compute correlation of S11 of white
cov2cor(white.s11.2) # compute correlation of S11.2 of white
cov2cor(white.s11)-cov2cor(white.s11.2) # the difference of the correlations of S11 & S11.2 of white
##========================================================================##

##======================logistic regression=============================##
#Logistic regression analysis

#For White Wine
white<-read.csv("white_clean.csv")  # Load data white wine
n<-nrow(white)	
trw<-white[1:floor(n*0.8),]	# Establish training dataset
attach(trw)
Yw<-quality # Yw as response
Yw1<-ifelse(Yw>=6,1,0)	# Define "high" and "low" quality
logw<-step(
  glm(Yw1 ~ fixed.acidity + volatile.acidity + citric.acid + residual.sugar + chlorides 
      + free.sulfur.dioxide + total.sulfur.dioxide + density + pH + sulphates + alcohol, family=binomial)
  ,direction="both",trace=0) # Fit model with training dataset and perform model selection at the same time
summary(logw) # Information of the final model
detach(trw)
tew<-white[(floor(n*0.8)+1):n,]	# Establish testing dataset
attach(tew)
prw<-predict(logw,newdata=tew,type="response")	# Predict the probabilities
prw<-ifelse(prw>=0.5,1,0)	# Set the ones with probability over 0.5 as "high quality"  
yw<-quality	# yw as true quality
yw1<-ifelse(yw>=6,1,0) # Define "high" and "low" quality 
tabw<-table(yw1,prw) 
tabw # Display the contingency table
sum(diag(prop.table(tabw))) # Calculate the proportion of the successful predictions
detach(tew)

#For Rew Wine
red<-read.csv("red_clean.csv")	# Load data red wine
n<-nrow(red)	
trr<-red[1:floor(n*0.8),]	# Establish training dataset
attach(trr)
Yr<-quality # Yr as response
Yr1<-ifelse(Yr>=6,1,0)	# Define "high" and "low" quality
logr<-step(
  glm(Yr1 ~ fixed.acidity + volatile.acidity + citric.acid + residual.sugar + chlorides 
      + free.sulfur.dioxide + total.sulfur.dioxide + density + pH + sulphates + alcohol, family=binomial)
  ,direction="both",trace=0) # Fit model with training dataset and perform model selection at the same time
summary(logr) # Information of the final model
detach(trr)
ter<-red[(floor(n*0.8)+1):n,]	# Establish testing dataset
attach(ter)
prr<-predict(logw,newdata=ter,type="response")	# Predict the probabilities
prr<-ifelse(prr>=0.5,1,0)	# Set the ones with probability over 0.5 as "high quality"  
yr<-quality	# yw as true quality
yr1<-ifelse(yr>=6,1,0) # Define "high" and "low" quality 
tabr<-table(yr1,prr) 
tabr # Display the contingency table
sum(diag(prop.table(tabr))) # Calculate the proportion of the successful predictions
detach(ter)

##====================================================================##