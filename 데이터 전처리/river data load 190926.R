library(ggplot2)
library(dplyr)
library(readr)
library(readxl)
library(plyr)


########## 하천데이터 load ############

riverA_sh <- read_csv("C:/Users/FESUB/WATER CONF/riverA_sh.csv")
riverA_fh <- read_csv("C:/Users/FESUB/WATER CONF/riverA_fh.csv")
riverA_2 <- read_xlsx("C:/Users/FESUB/WATER CONF/riverA_2.xlsx")
riverA_3 <- read_xlsx("C:/Users/FESUB/WATER CONF/riverA_3.xlsx")
riverA_4 <- read_xlsx("C:/Users/FESUB/WATER CONF/riverA_4.xlsx")
riverA_5 <- read_csv("C:/Users/FESUB/WATER CONF/riverA_5.csv")
riverA_6 <- read_csv("C:/Users/FESUB/WATER CONF/riverA_6.csv")

riverB_1 <- read_csv("C:/Users/FESUB/WATER CONF/riverB_1.csv")
riverB_2 <- read_xlsx("C:/Users/FESUB/WATER CONF/riverB_2.xlsx")
riverB_3 <- read_xlsx("C:/Users/FESUB/WATER CONF/riverB_3.xlsx")
riverB_4 <- read_xlsx("C:/Users/FESUB/WATER CONF/riverB_4.xlsx")
riverB_5 <- read_csv("C:/Users/FESUB/WATER CONF/riverB_5.csv")

riverD_1 <- read_csv("C:/Users/FESUB/WATER CONF/riverD_1.csv")
riverD_2 <- read_csv("C:/Users/FESUB/WATER CONF/riverD_2.csv")
riverD_3 <- read_csv("C:/Users/FESUB/WATER CONF/riverD_3.csv")
riverD_4 <- read_csv("C:/Users/FESUB/WATER CONF/riverD_4.csv")
riverD_5 <- read_csv("C:/Users/FESUB/WATER CONF/riverD_5.csv")

riverE_1 <- read_csv("C:/Users/FESUB/WATER CONF/riverE_1.csv")
riverE_2 <- read_csv("C:/Users/FESUB/WATER CONF/riverE_2.csv")
riverE_3 <- read_csv("C:/Users/FESUB/WATER CONF/riverE_3.csv")
riverE_4 <- read_csv("C:/Users/FESUB/WATER CONF/riverE_4.csv")
riverE_5 <- read_csv("C:/Users/FESUB/WATER CONF/riverE_5.csv")

riverF_1 <- read_csv("C:/Users/FESUB/WATER CONF/riverF_1.csv")
riverF_2 <- read_csv("C:/Users/FESUB/WATER CONF/riverF_2.csv")
riverF_3 <- read_csv("C:/Users/FESUB/WATER CONF/riverF_3.csv")

############# 데이터 설명 ##############
#### 1 : 한강 / 2 : 낙동강 / 3 : 금강 / 4: 영산강 / 5: ?####

#### A : 하천수 / B : 호소수(댐) / D : 농업용수 ####
#### E : 산단하천 / F : 도시관류 ####

############ 용수별 데이터 통합 ################
riverA_fh <- riverA_fh[,-1]
riverA_sh <- riverA_sh[,-1]
riverA_2 <- riverA_2[,-1]
riverA_3 <- riverA_3[,-1]
riverA_4 <- riverA_4[,-1]
riverA_5 <- riverA_5[,-1]
riverA_6 <- riverA_6[,-1]

riverB_1 <- riverB_1[,-1]
riverB_2 <- riverB_2[,-1]
riverB_3 <- riverB_3[,-1]
riverB_4 <- riverB_4[,-1]
riverB_5 <- riverB_5[,-1]

riverD_1 <- riverD_1[,-1]
riverD_2 <- riverD_2[,-1]
riverD_3 <- riverD_3[,-1]
riverD_4 <- riverD_4[,-1]
riverD_5 <- riverD_5[,-1]

riverE_1 <- riverE_1[,-1]
riverE_2 <- riverE_2[,-1]
riverE_3 <- riverE_3[,-1]
riverE_4 <- riverE_4[,-1]
riverE_5 <- riverE_5[,-1]

riverF_1 <- riverF_1[,-1]
riverF_2 <- riverF_2[,-1]
riverF_3 <- riverF_3[,-1]

riverA <- rbind.fill(riverA_fh,riverA_sh,riverA_2,riverA_3,riverA_4,riverA_5,riverA_6)
riverB <- rbind.fill(riverB_1, riverB_2, riverB_3, riverB_4, riverB_5)
riverD <- rbind.fill(riverD_1, riverD_2, riverD_3, riverD_4, riverD_5)
riverE <- rbind.fill(riverE_1, riverE_2, riverE_3, riverE_4, riverE_5)
riverF <- rbind.fill(riverF_1, riverF_2, riverF_3)

river <- rbind.fill(riverA,riverB,riverD,riverE,riverF)

############ Conposite Key ##############
###   복합키 기본컨셉 : 
###   STEP 1 : 날짜 복사하기 
###   STEP 2 : 지역 복사하기 
###   STEP 3 : 지역의 경우에는 두개만 자르기 '시군구'(ex, 서울특별시 강남구)
###   STEP 4 : YYYYMMDDRRR composite key 생성

river$ADDR <- 
river$WMCYMD <-




