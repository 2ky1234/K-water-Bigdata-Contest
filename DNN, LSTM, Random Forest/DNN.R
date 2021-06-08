#### DNN R code ####
### 데이터 로드 및 라이브러리 ###
library(MASS)
library(neuralnet)
library(dplyr)
library(ggplot2)
library(rsq)
library(readr)
library(caret)
bdat <- read_csv('C:/Users/FESUB/Desktop/수자원 공모전/raw_river.csv')
 bdat <- bdat[,-1]
 bdat <- bdat[,-1]
 bdat <- bdat[-1,]
# bdat <- bdat[1:30000,]
# bdat <- select(bdat,c('ITEM_TEMP','MEAN_TEMP','MEAN_LAND', 'L_TEMP', 'U_TEMP',  'L_TEMP.1', 'MEAN_DEW', 'MEAN_STPR', 'MEAN_SUN', 'ITEM_DOC', 'U_hPa', 'ITEM_PH', 'ITEM_COD' , 'L_hPa', 'ITEM_TP', 'MEAN_PRES', 'ITEM_BOD', 'ITEM_SS', 'ITEM_TN', 'MEAN_hPa', 'SUM_SUN'))
bdat <- select(bdat,c('ITEM_PH','ITEM_DOC',
                      'ITEM_TP',
                      'ITEM_TN',
                      'ITEM_TEMP',
                      'ITEM_COD',
                      'ITEM_BOD',
                      'L_hPa',
                      'MEAN_TEMP',
                      'MEAN_hPa',
                      'MEAN_LAND',
                      'U_TEMP',
                      'MAX_MOMENT_WIND',
                      'MEAN_SUN',
                      'L_TEMP',
                      'MAX_MIN',
                      'L_REHU',
                      'MEAN_MOIS',
                      'SUM_SUN',
                      'MEAN_STPR'
))
set.seed(100)


### 데이터 Understading ###
str(bdat)
summary(bdat)

### 50% 랜덤 추출 ###
i <- sample(1:nrow(bdat), round(0.5*nrow(bdat)))
max1 <- apply(bdat, 2, max)
min1 <- apply(bdat, 2, min)

### 변수의 표준화 과정 ###
 sdat <- scale(bdat,center=min1,scale = max1 - min1) 
 sdat <- as.data.frame(sdat)
 head(sdat,3)
 str(sdat)
# sdat <- bdat
### 신경망 모델 구축 및 신경망 그래프 그리기 ###
train <- sdat[i,] #학습, 훈련샘플 training
test <- sdat[-i,] #테스트샘플 test
n <- names(train) ;n
form <- as.formula(paste('ITEM_PH~',paste(n[!n %in% n[1]],collapse = '+'))) 
form
nn1 <- neuralnet(form,data=train,hidden = c(2,2),stepmax=1e7,linear.output = T)


# nn2 <- neuralnet(form,data=train,hidden = c(3,2),stepmax=1e7,linear.output = T)


# nn3 <- neuralnet(form,data=train,hidden = c(3,3),stepmax=1e7,linear.output = T)
summary(nn1)
plot(nn1)

### 모형 추정: 위의 그래프는 50%의 training data만을 사용하였으니 나머지 50% test data를 쓰자. ###
pred.nn0 <- neuralnet::compute(nn1,test[,2:20])
summary(pred.nn0)
pred0 <- pred.nn0$net.result*(max(bdat[,1])-min(bdat[,1]))+min(bdat[,1])
head(pred0)
### 학습샘플의 실제값과 예측값 (적합값)을 비교해보자. ###
compare <- as.data.frame(cbind(bdat[i,1],pred0))
gap <- compare$V1 - compare$V2 
sqrt(var(gap))
head(compare,50)

### 예측 정확도 평가: 모형 추정에 사용되지 않은 test data를 가지고 예측을 해보자. ###
pred.nn1 = neuralnet::compute(nn1,test[,2:20]) #목표 변수 제외, 새로운 변수로 간주하고 nn1에 적용
pred1 = pred.nn1$net.result*(max(bdat[,1])-min(bdat[,1]))+min(bdat[,1]) #목표변수를 조정전 변수값으로 환원. 역변환
head(cbind(bdat[-i,1],pred1),50) #좌측은 test 변수의 실제값, 우측은 예측값(적합값), 14번째 값은 목표변수, pred1은 예측값(적합값)
head(cbind(bdat[-i,1],pred1)[,1],10)
head(cbind(bdat[-i,1],pred1),10)
obs <-cbind(bdat[-i,1],pred1)[,1]
pdt <-cbind(bdat[-i,1],pred1)[,2]
out = cbind(obs,pdt)
head(out)
out = as.data.frame(out)
which.min(abs(out$obs - out$pdt))
out[43,]
out[197,]



preds <- out$obs
actual <- out$pdt
rss <- sum((preds - actual) ^ 2)  ## residual sum of squares
tss <- sum((actual - mean(actual)) ^ 2)  ## total sum of squares
rsq <- 1 - rss/tss
rsq

R2(out$pdt,out$obs, form='traditional')

RMSE(out$pdt,out$obs)

PMSE = sum((bdat[-i,6] - pred1)^2) / nrow(test)
PMSE



ggplot(out,aes(x=obs,y=pdt))+geom_count(aes(alpha=0.0000015,colour=..n..))+xlim(0,1)+ylim(0,1)+ theme(panel.grid.minor = element_blank())
ggplot(out,aes(x=obs,y=pdt))+geom_point()+xlim(0,1)+ylim(0,1)
