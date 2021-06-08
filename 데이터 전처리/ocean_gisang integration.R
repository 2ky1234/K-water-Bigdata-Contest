library(dlookr)
library(dplyr)
library(geosphere)
##### 데이터 가져오기
### 해양기상
setwd("D:/Project/2019 케이워터 공모전/데이터/해양기상 데이터/")
gisang <- read.csv("ocean_gisang_data.csv")
summary(gisang)
gisang <- gisang[,-1]
### 해양
setwd("D:/Project/2019 케이워터 공모전/데이터/해양 데이터/")
ocean <- read.csv("ocean_전처리_위경도_완료.csv")
summary(ocean)
ocean <- ocean[,-1]
ocean <- ocean %>% rename(longitude='longtitude')

##### ocean 데이터와 기상청 위치데이터 위경도거리 계산(distGEO)
### 기상청 지역, 위경도 가져오기
gisang_lonlat <- gisang %>% select('지점명', '위도', '경도')
gisang_lonlat <- unique(gisang_lonlat)
colnames(gisang_lonlat) <- c("ADDR", "lat", "lon")
gisang_lonlat <- gisang_lonlat %>% arrange(ADDR)

### 해양 지역, 위경도 가져오기
ocean_lonlat <- ocean %>% select('측정소', 'longitude', 'latitude')
ocean_lonlat <- unique(ocean_lonlat)
colnames(ocean_lonlat) <- c("ADDR", "lon", "lat")
ocean_lonlat <- ocean_lonlat %>% arrange(ADDR)
ocean_lonlat <- na.omit(ocean_lonlat)

### ocean와 기상청 거리계산
ocean_gisang_dist <-distm(ocean_lonlat[,c('lon','lat')], gisang_lonlat[,c('lon','lat')],fun=distGeo)
ocean_gisang_dist <- ocean_gisang_dist/1000
ocean_gisang_dist <- as.data.frame(ocean_gisang_dist)
ocean_gisang_dist$dist <- 1000000
# ocean와 가까운 기상관측소 매칭
for (i in (1:nrow(ocean_gisang_dist))){
  ocean_gisang_dist[i,ncol(ocean_gisang_dist)] <- which.min(ocean_gisang_dist[i,])
}
ocean_gisang_dist$dist
gisang_list <- gisang_lonlat$ADDR
ocean_gisang_dist$ADDR <- gisang_list[ocean_gisang_dist$dist]
# ocean_lonlat에 가까운 기상관측소 매칭
ocean_lonlat$address <- ocean_gisang_dist$ADDR

##### ocean 데이터, 기상청 데이터 합치기
ocean_matching <- ocean_lonlat %>% select(ADDR, address)
gisang <- gisang %>% rename(address='지점명')
ocean <- ocean %>% rename(ADDR = '측정소')
ocean <- left_join(ocean, ocean_matching, by='ADDR')

### 일자 맞춰주기
gisang$일시 <- as.character(gisang$일시)
ocean <- ocean %>% rename(date='관측일자')
gisang <- gisang %>% rename(date='일시')
gisang$date <- as.character(gisang$date)
ocean$date <- as.character(ocean$date)
### 키 만들기(지역(gisang), 일시(date))
ocean$key <- paste0(ocean$date, ocean$address)
gisang$key <- paste0(gisang$date, gisang$address)
### 합치기
ocean_gisang <- left_join(ocean, gisang, by='key')
summary(ocean_gisang)

##### 저장하기
setwd("D:/Project/2019 케이워터 공모전/데이터/해양기상 데이터/")
write.csv(ocean_gisang, "ocean_gisang.csv")

a <- ocean_gisang
summary(a)
a <- na.omit(a)
a <- ocean_gisang %>% diagnose()
