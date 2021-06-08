##### 데이터 가져오기
### 기상청
setwd("D:/Project/2019 케이워터 공모전/데이터/기상청 데이터/")
gisang <- read.csv("gisang_data.csv")
### 하천
setwd("D:/Project/2019 케이워터 공모전/데이터/하천 데이터/")
load("river image 190926.RData")
remove(riverA, riverA_2, riverA_3, riverA_4, riverA_5, riverA_6, riverA_fh, riverA_sh, riverB, riverB_1, riverB_2, riverB_3, riverB_4, riverB_5, riverD, riverD_1, riverD_2, riverD_3, riverD_4, riverD_5, riverE, riverE_1, riverE_2, riverE_3, riverE_4, riverE_5, riverF, riverF_1, riverF_2, riverF_3)

##### river에 위도, 경도 붙인 것 가져오기
setwd("D:/Project/2019 케이워터 공모전/데이터/전처리/")
river_lonlat <- read.csv("river_lonlat.csv")
river_lonlat <- river_lonlat[,-1]

##### river 데이터에 위경도데이터 붙이기
river_lonlat <- river_lonlat[,-2]
river_all <- left_join(river, river_lonlat, by="ADDR")

##### river 데이터와 기상청 위치데이터 위경도거리 계산(distGEO)
### 기상청 지역, 위경도 가져오기
gisang_lonlat <- gisang %>% select(지점명, 기상_위도, 기상_경도)
gisang_lonlat <- unique(gisang_lonlat)
gisang_lonlat <- gisang_lonlat %>% arrange(지점명)
colnames(gisang_lonlat) <- c("ADDR", "lat", "lon")

### river와 기상청 거리계산
river_gisang_dist <-distm(river_lonlat[,c('lon','lat')], gisang_lonlat[,c('lon','lat')],fun=distGeo)
river_gisang_dist <- river_gisang_dist/1000
river_gisang_dist <- as.data.frame(river_gisang_dist)
river_gisang_dist$dist <- 1000000
# river와 가까운 기상관측소 매칭
for (i in (1:nrow(river_gisang_dist))){
  river_gisang_dist[i,ncol(river_gisang_dist)] <- which.min(river_gisang_dist[i,])
}
river_gisang_dist$dist
gisang_list <- gisang_lonlat$ADDR
river_gisang_dist$ADDR <- gisang_list[river_gisang_dist$dist]
# river_lonlat에 가까운 기상관측소 매칭
river_lonlat$address <- river_gisang_dist$ADDR

##### river 데이터, 기상청 데이터 합치기
river_matching <- river_lonlat %>% select(ADDR, address)
gisang <- gisang %>% rename(address='지점명')
river <- left_join(river, river_matching, by='ADDR')

### 일자 맞춰주기
gisang$일시 <- as.character(gisang$일시)
gisang$일시 <- gsub('-','.',gisang$일시)
river <- river %>% rename(date='WMCYMD')
gisang <- gisang %>% rename(date='일시')
gisang$date <- as.character(gisang$date)
river$date <- as.character(river$date)
### 키 만들기(지역(gisang), 일시(date))
river$key <- paste0(river$date, river$address)
gisang$key <- paste0(gisang$date, gisang$address)
### 합치기
river_gisang <- left_join(river, gisang, by='key')
summary(river_gisang)

##### 저장하기
write.csv(river_gisang, "river_gisang.csv")
