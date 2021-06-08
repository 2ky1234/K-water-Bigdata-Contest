
library(randomForest)
library(dotCall64)
library(dplyr)
library(readr)
library(e1071)

gc()
rm(list=ls())
rm()
memory.limit(30000)
### 종속변수인 
db <- read_csv('C:/Users/FESUB/Desktop/수자원 공모전/raw_river.csv')

##### 모델링
db_set <- db

## 샘플링
db_set$index <- 1:nrow(db_set)
db_set <- db_set %>% filter(db_set$index%%5==1)
db_set <- db_set[,-1]
db_set <- db_set[,-1]
db_set$ITEM_TEMP <- as.numeric(db_set$ITEM_TEMP)
db_set <- db_set %>% mutate_if(is.character, as.factor)
db_set <- round(db_set,digits=3)
# db_set <- as.data.frame(db_set)

#names(db_set)

# 변수개수를 전체변수 수의 제곱근으로 지정
db_set$ITEM_SS <- as.numeric(db_set$ITEM_SS)
mtrynum <- round(sqrt(ncol(db_set)))
model <- randomForest(ITEM_SS~., data=db_set, importance=TRUE, ntree=300, mtry=mtrynum, proximity=TRUE,na.action=na.omit)
model
summary(model)
#importance(model)
#varImpPlot(model, main="Importance of variables")

##### 저장
# importance of variables 저장/변수명 매칭
# matching <- read.csv("C:/Users/FESUB/Desktop/수자원 공모전/MATCHING.csv")
# matching$var <- as.character(matching$var)
a <- as.data.frame(importance(model))
a$var <- rownames(a)
# 
# a_MDA <- a %>% select(c(var,MeanDecreaseAccuracy)) %>% arrange(desc(MeanDecreaseAccuracy)) %>% head(20)
# a_MDA <- left_join(a_MDA, matching, by="var")
# a_MDA <- subset(a_MDA, select=c(var, info, MeanDecreaseAccuracy))
# a_MDG <- a %>% select(c(var,MeanDecreaseGini)) %>% arrange(desc(MeanDecreaseGini)) %>% head(20)
# a_MDG <- left_join(a_MDG, matching, by="var")
# a_MDG <- subset(a_MDG, select=c(var, info, MeanDecreaseGini))
# 
# imp_var <- bind_cols(a_MDA, a_MDG)

# 중요변수 저장
setwd("C:/Users/FESUB/Desktop/수자원 공모전/")
write.csv(imp_var, file="MS_importtance of variables.csv")

b <- a$var
