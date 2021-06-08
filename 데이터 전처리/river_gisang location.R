##### library
library(ggmap)
library(geosphere)

##### 하천데이터 가져오기
setwd("D:/Project/2019 케이워터 공모전/데이터/하천 데이터/")
load("river image 190926.RData")
remove(riverA, riverA_2, riverA_3, riverA_4, riverA_5, riverA_6, riverA_fh, riverA_sh, riverB, riverB_1, riverB_2, riverB_3, riverB_4, riverB_5, riverD, riverD_1, riverD_2, riverD_3, riverD_4, riverD_5, riverE, riverE_1, riverE_2, riverE_3, riverE_4, riverE_5, riverF, riverF_1, riverF_2, riverF_3)

##### google api로 위경도 가져오기
register_google(key = "AIzaSyCkFvM8tj2mTeAIh1orfH3A7id2U0nElO8")

river_addr <- as.data.frame(table(river$ADDR))
colnames(river_addr) <- c("ADDR", "a")
river_addr$ADDR <- as.character(river_addr$ADDR)
river_addr$ADDR <- enc2utf8(river_addr$ADDR)

river_lonlat <- mutate_geocode(river_addr,ADDR,source='google')
prop.table(table(is.na(river_lonlat)))

river_lonlat[79,c("lon","lat")] <- c(127.9192, 37.4137)
river_lonlat[112,c("lon","lat")] <- c(127.7485, 37.8947)
river_lonlat[166,c("lon","lat")] <- c(128.0431, 37.5789)
river_lonlat[251,c("lon","lat")] <- c(127.0490, 37.9034)
river_lonlat[462,c("lon","lat")] <- c(128.7645, 36.5804)
river_lonlat[489,c("lon","lat")] <- c(128.3130, 34.9908)
river_lonlat[589,c("lon","lat")] <- c(128.0782, 35.3232)
river_lonlat[598,c("lon","lat")] <- c(128.0361, 35.1825)
river_lonlat[676,c("lon","lat")] <- c(128.1048, 35.3802)
river_lonlat[831,c("lon","lat")] <- c(128.9329, 36.5674)
river_lonlat[897,c("lon","lat")] <- c(128.2969, 36.5647)
river_lonlat[989,c("lon","lat")] <- c(128.4695, 35.8402)
river_lonlat[1106,c("lon","lat")] <- c(127.2644, 36.4747)
river_lonlat[1107,c("lon","lat")] <- c(127.2383, 36.4740)
river_lonlat[1112,c("lon","lat")] <- c(127.2305, 36.6026)
river_lonlat[1113,c("lon","lat")] <- c(127.2104, 36.4978)
river_lonlat[1123,c("lon","lat")] <- c(129.3291, 35.5163)
river_lonlat[1144,c("lon","lat")] <- c(129.1317, 35.5412)
river_lonlat[1282,c("lon","lat")] <- c(127.4058, 35.1907)
river_lonlat[1882,c("lon","lat")] <- c(126.7463, 36.7414)
river_lonlat[1938,c("lon","lat")] <- c(126.6408, 36.5100)
river_lonlat[1955,c("lon","lat")] <- c(127.8468, 36.8940)
river_lonlat[1966,c("lon","lat")] <- c(127.7998, 36.6802)

prop.table(table(is.na(river_lonlat)))
table(is.na(river_lonlat$lon))

setwd("D:/Project/2019 케이워터 공모전/데이터/전처리/")
write.csv(river_lonlat, "river_lonlat.csv")