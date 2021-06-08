library(plyr)
library(dplyr)
library(ggplot2)
library(dlookr)
library(Amelia)
### 딥러닝에 활용할 독립변수 전처리 ###
### 1. NA처리에 관한 부분 ###
### 2. 향후 활용을 위해 '예보'가 가능한 독립변수만 추출 (홈페이지나, 데이터등을 통해 근거 제시)###
### 3. 시간이 남는다면 이상치 제거 ###

########
diagnose <- river_gisang %>% diagnose()
diagnose <- as.data.frame(diagnose)

#결측치 30%dltkd wprj
index_na <- c()
for (i in 1:ncol(river_gisang))
{
  if(sum(is.na(river_gisang[i])) >= nrow(river_gisang)*0.12)
  {
    index_na <- c(index_na,i)
  }
}
river_gisang <- river_gisang[,-index_na]
select_col <- colnames(river_gisang)

diagnose <- river_gisang %>% diagnose()
diagnose <- as.data.frame(diagnose)
########

                       
river_gisang <- river_gisang %>%  rename(MEAN_TEMP='평균기온..C.',MEAN_WIND='평균.풍속.m.s.',MEAN_MOIS='평균.상대습도...',MEAN_PRES='평균.해면기압.hPa.',MEAN_SUN='가조시간.hr.')

#########


str(river_gisang)

river_gisang <- subset(river_gisang, select = -c(ORG_NM,WMOD,WMWK,date.x,date.y))

factor_file <- subset(river_gisang, select = c(ADDR, ITEM_SS,ITEM_TP,address.x,key,address.y))
other_file <- subset(river_gisang, select = -c(ADDR, ITEM_SS,ITEM_TP,address.x,key,address.y))

missing <- other_file
summary(other_file)

#amelia 명령을 입력하여 결측치가 처리된 데이터셋 새로 생s성
#5개의 데이터셋이 추천됨
imputed.missing <- amelia(x = missing, m = 5)
# str(missing)
# 
# summary(imputed.missing)

# imputed.missing

#저장하기
write.amelia(imputed.missing,file.stem = "impute", format = "csv")

#불러오기
impute1 <- read.table("impute1.csv", header = T, sep = ',', na.strings = NA, dec = ",", strip.white = T)
impute2 <- read.table("impute2.csv", header = T, sep = ',', na.strings = NA, dec = ",", strip.white = T)
impute3 <- read.table("impute3.csv", header = T, sep = ',', na.strings = NA, dec = ",", strip.white = T)
impute4 <- read.table("impute4.csv", header = T, sep = ',', na.strings = NA, dec = ",", strip.white = T)
impute5 <- read.table("impute5.csv", header = T, sep = ',', na.strings = NA, dec = ",", strip.white = T)

#########

deep_learning_example <- river_gisang %>% select(ITEM_TEMP,MEAN_TEMP,MEAN_WIND,MEAN_MOIS,MEAN_PRES,MEAN_SUN) 
deep_learning_example <- na.omit(deep_learning_example)


write.csv(deep_learning_example,file= 'Deep_Learning_example.csv')


