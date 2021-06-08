library(dlookr)
library(dplyr)
library(geosphere)
##### 데이터 가져오기
### 기상청
setwd("D:/Project/2019 케이워터 공모전/데이터/기상청 데이터/")
gisang <- read.csv("gisang_data.csv")
colnames(gisang) <- c("num", "지점",	"일시",	"평균기온..C.",	"최저기온..C.", "최저기온.시각.hhmi.",	"최고기온..C.",	"최고기온.시각.hhmi.",	"강수.계속시간.hr.",	"X10분.최다.강수량.mm.",	"X10분.최다강수량.시각.hhmi.",	"X1시간.최다강수량.mm.",	"X1시간.최다.강수량.시각.hhmi.",	"일강수량.mm.",	"최대.순간.풍속.m.s.",	"최대.순간.풍속.풍향.16방위.",	"최대.순간풍속.시각.hhmi.",	"최대.풍속.m.s.",	"최대.풍속.풍향.16방위.",	"최대.풍속.시각.hhmi.",	"평균.풍속.m.s.",	"풍정합.100m.",	"평균.이슬점온도..C.",	"최소.상대습도...",	"최소.상대습도.시각.hhmi.",	"평균.상대습도...",	"평균.증기압.hPa.",	"평균.현지기압.hPa.",	"최고.해면기압.hPa.",	"최고.해면기압.시각.hhmi.",	"최저.해면기압.hPa.",	"최저.해면기압.시각.hhmi.",	"평균.해면기압.hPa.",	"가조시간.hr.",	"합계.일조.시간.hr.",	"X1시간.최다일사.시각.hhmi.",	"X1시간.최다일사량.MJ.m2.",	"합계.일사.MJ.m2.",	"일.최심신적설.cm.",	"일.최심신적설.시각.hhmi.",	"일.최심적설.cm.",	"일.최심적설.시각.hhmi.",	"합계.3시간.신적설.cm.",	"평균.전운량.1.10.",	"평균.중하층운량.1.10.",	"평균.지면온도..C.","최저.초상온도..C.",	"평균.5cm.지중온도..C.",	"평균.10cm.지중온도..C.",	"평균.20cm.지중온도..C.",	"평균.30cm.지중온도..C.",	"X0.5m.지중온도..C.",	"X1.0m.지중온도..C.",	"X1.5m.지중온도..C.",	"X3.0m.지중온도..C.",	"X5.0m.지중온도..C.",	"합계.대형증발량.mm.",	"합계.소형증발량.mm.",	"X9.9강수.mm.",	"안개.계속시간.hr.",	"지점명",	"기상_위도",	"기상_경도")
summary(gisang)
gisang <- gisang[,-1]
### 해양
setwd("D:/Project/2019 케이워터 공모전/데이터/해양 데이터/")
ocean <- read.csv("ocean_전처리_위경도_완료.csv")
colnames(ocean) <- c("num", "측정소",	"측정소코드",	"관측일자",	"전기전도도",	"수온",	"탁도",	"PH",	"용존산소량_DO",	"염분",	"일사량",	"기온",	"상대습도",	"풍속",	"풍향",	"강수량",	"클로로필",	"남조류",	"화학적산소요구량_COD",	"수소이온농도",	"latitude",	"longitude")
summary(ocean)
ocean <- ocean[,-1]

##### ocean 데이터와 기상청 위치데이터 위경도거리 계산(distGEO)
### 기상청 지역, 위경도 가져오기
gisang_lonlat <- gisang %>% select('지점명', '기상_위도', '기상_경도')
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
write.csv(ocean_gisang, "ocean_gisang.csv")

a <- ocean_gisang
summary(a)
a <- na.omit(a)
a <- ocean_gisang %>% diagnose()
