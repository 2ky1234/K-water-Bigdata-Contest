##### import library
library(dplyr)
library(tidyverse)
library(fs)

##### 디렉토리에 있는 파일 리스트
list.files(path="D:/Project/2019 케이워터 공모전/데이터/해양기상 데이터/RAW DATA/", pattern = NULL)

##### 데이터 합치기
data_dir <- "D:/Project/2019 케이워터 공모전/데이터/해양기상 데이터/RAW DATA/"
#fs::dir_ls(data_dir)
csv_files <- fs::dir_ls(data_dir, regexp="\\.csv$")
#csv_files[1]
#read.csv(csv_files[1])
file <- csv_files %>% map_dfr(read.csv)

##### 지점코드로 위도, 경도 합치기
### 지점코드 데이터 가져오기
stninfo <- read.csv("D:/Project/2019 케이워터 공모전/데이터/해양기상 데이터/stninfo.csv")
stninfo_simple <- stninfo %>% select(지점, 지점명, 위도, 경도)
stninfo_simple <- stninfo_simple %>% rename(지점=)

### 합치기
#colnames(all_file)
#colnames(stninfo_simple)
all_file_stn <- left_join(file, stninfo_simple, by="지점")
#colnames(all_file_stn)

table(all_file_stn$지점명)

##### 저장
setwd("D:/Project/2019 케이워터 공모전/데이터/해양기상 데이터/")
write.csv(all_file_stn, "ocean_gisang_data.csv")
