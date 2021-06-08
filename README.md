# K-water-Bigdata-Contest
한국수자원공사  ‘제3회 빅데이터 경진대회’, 환경부 장관상을 수상한 ‘딥러닝을 이용한 수상레저적합 요인 예측 및 지수 개발’ 프로젝트 입니다. 


## 프로젝트 보고서
![image](https://user-images.githubusercontent.com/80387630/121210405-9c7d6a00-c8b6-11eb-88c6-6a8497ebffba.png)

## 배경 및 목적
수상레저는 스킨스쿠버, 수상스키, 레프팅을 포함하여 물에서 하는 모든 놀이 및 활동으로, 지난해 수상레저 이용객이 519만명에 이를 정도로 많은 국민들이 수상레저 활동에 참여하고 있다. 수상레저 활동을 하는데 있어서, 안전하고 쾌적한 수상 환경은 필수적이다. 따라서 수상레저활동자는 수상레저를 즐기기에 앞서서, 물이 수상레저를 즐기기에 적합한 환경인지에 대한 정보를 필요로 한다. 
 특히 근래의 여러 사건사고 이후 국민의 관심사가  ‘안전’으로 집중되고, 또한 매년 수상레저간에 사망사고가 안전사고로 인해 발생한다(물놀이에서만 수십명) .‘국민안전처’에 의하면 수온, 수심, 유속등이 수상레저 안전사고 예방에 중요하다고 한다, 이러한 안전과 관련이 큰 지표들을 사전에 알려준다면 국민의 수상레저 안전사고를 예방하는데 도움이 될 것이다.
 본 과제의 목표를 ‘데이터마이닝과 딥러닝을 통한 수상레저적합 요인 예측 및 지수개발’로 잡고 구체적인 목표는 수상레저와 관련된 여러 지표들의 예측 값을 제공하며, 국민들의 눈높이에 맞춰 한눈에 파악가능한 (그림과 같은) 지수 UI(User Interface)를 제공하는 것이다. 이를 통해 수상레저 계획자들이 미리 수상 환경을 체크할 수 있도록 정보를 제공할 수 있다. 특히, 수상레저별로 사용되는 주요변수들이 다른데, 이러한 부분도 고려하여 사용자가 선택한 각각의 수상레저가 적합한지에 대해 지표로 제공 할 수 있다.

## 분석 주요내용
분석의 목적은 기상예보데이터를 이용하여 물관련지표들을 예측한다. 예측된 값을 국민들이 수상레저에 이용할 수 있도록 눈높이에 맞게 가공하여 제공하는 것이다. 따라서 분석의 핵심은 ‘물관련지표예측’과 ‘이용편의를 위한 가공’이 되며, 분석의 경우 크게 3가지 기법을 사용하였다.
첫째, DNN
둘째, LSTM
셋째, Lasso, Ridge

또한 분석을 위한 종속변수 및 독립변수 선정은 아래와 같은 과정을 따른다.
첫째, 종속변수의 경우 수상레저와 밀접하게 관련이 있는 변수를 선정하였다.
둘째, 도메인 지식을 사용하여 예측 지표와 관련 없는 변수를 솎아냈고
셋째, 이후 Random Forest를 이용하여 종속변수와 관련이 큰 변수들을 선정하였다.

## 활용 데이터
### 데이터 수집 
활용한 데이터는 하천 및 해양 수질데이터와 기상데이터로, 크게 네 가지 데이터를 사용하였다. 하천데이터로는 공공데이터포털에서 제공하는 수질자동측정망 데이터를 사용하였고, 해양데이터로는 국가해양환경정보통합시스템(MEIS)에서 제공하는 해양수질자동측정망 데이터를 사용하였다. 또한 하천과 해양 각각의 데이터에 기상 일자료를 통합하기 위해, 기상자료개방포털에서 제공하는 종관기상관측 데이터와 해양기상부이 데이터를 사용하였다. 위 데이터 중 수질자동측정망 데이터를 제외한 세 개의 데이터는 csv파일로 제공받았으며, 수질자동측정망 데이터의 경우에는 openAPI를 통해 수집하였다. python에서 발급받은 service key를 통해 json형식으로 데이터를 가져온 후, 파싱과정을 거쳐 csv형식으로 변환하였다.
### 데이터 전처리
학습에 적합한 데이터를 만들기 위해, 데이터 전처리를 진행하였다. 먼저 이상치가 있으면 모델이 잘못 훈련될 수 있으므로, 사분범위에서 크게 벗어난 값을 이상치로 설정하여 제거하였다. 결과적으로 각 변수에 대해서 Q1-1.5*IQR보다 작거나 Q3+1.5*IQR보다 큰 값이 제거되었다. 또한 종속변수 및 독립변수의 값이 NA면 예측을 할 수 없으므로, 학습 및 예측에 필수적인 데이터에 대해 NA를 포함한 행을 제거하였다.
날짜 변수에서 값들의 형식이 다른 것이 파악되었다. 이 문제를 해결하기 위하여 날짜표현식을 정하여 이러한 형식에 어긋나는 날짜데이터는 제거하였다. 하천 및 해양데이터와 각각의 기상데이터를 통합하기 위해서, ‘날짜’와 ‘지역’ 변수에 대한 값을 통합하여 Composite Key를 생성하였다.
### 데이터 통합
하천과 해양에 대해 수질데이터와 기상데이터를 통합해야 하는데, 수질데이터와 기상데이터의 지역은 각각의 데이터를 측정하는 관측소의 위치가 달라 지역 값을 매칭 할 수 없다. 따라서 각 지역의 위도와 경도를 R의 ggmap을 통해 가져와 변수를 생성한 후, 수질데이터의 지역과 가장 가까운 기상데이터의 지역 위치를 유클리디안 거리로 계산하여 매칭하였다. 또한 아래와 같은 식을 적용하여 MinMax 방법의 정규화를 통해 모든 값을 0부터 1사이의 값으로 변환하여 줌으로써, 모델에 사용하기 위한 최종적인 데이터셋을 완성하였다. 
 
만들어진 데이터셋은 하천에 대한 데이터와 해양에 대한 데이터로 총 두 가지이며, 각각 수질 및 기상에 대한 데이터를 포함한다.

## Random Forest, DNN, LSTM, Lasso & Ridge
### Random Forest
![image](https://user-images.githubusercontent.com/80387630/121207548-57583880-c8b4-11eb-8eb2-2e9b353a15a3.png)

ITEM_TEMP(수온)을 종속변수로, 그 외 변수들을 독립변수로 설정한 뒤, 랜덤포레스트를 실행하여 선정된 변수의 일부는 다음과 같다. 상위의 변수들을 살펴보면, ‘평균 기온’, ‘평균 지온’, ‘최저 기온’ 등이 있다. 이와 같은식으로 예측이 필요한 모든 종속변수에 대해 실행하였다.
### DNN
![image](https://user-images.githubusercontent.com/80387630/121207703-76ef6100-c8b4-11eb-9569-1158b36ff878.png)

[Modeling① - DNN(Deep Neural Network)] 통합 데이터를 DNN모델에 적용하기 전, 예측 성능을 파악하기 위하여 train set과 test set을 각각 7:3으로 랜덤 추출하였다. 수온 변수(ITEM_TEMP)를 예측변수로 설정하여 DNN모델에 학습시킨 Neuralnet 모형은 다음과 같다.
위의 모델의 경우 3개의 hidden layer와 각각 3개의 node를 사용하였다. 다음은 모델링 후, 수온에 대한 예측의 결과를 그래프로 나타낸 것이다.  R square값은 0.788, RMSE값은 0.061의 결과를 얻었다.
### LSTM
![image](https://user-images.githubusercontent.com/80387630/121207946-a69e6900-c8b4-11eb-9692-392303473e96.png)

[Modeling② - LSTM(Long Short-Term Memory)]
모델을 돌릴 때에는 layer는 20개로 설정하고, loss의 기준을 ‘MSE’로, optimizer는 ‘adam’을 사용했을 때 가장 성능이 좋았다. 또한 epoch를 100으로 크게 설정하고 early stop을 적용하여 더이상 모델의 성능이 좋아지지 않고 머무르면 자동으로 멈추게 하였다.
### Lasso & Ridge
[Modeling③ - Regression(Polynomial, Ridge & Lasso)]
alpha의 값이 작아지면 규제가 작아 원래의 회귀식과 유사해지므로 각각 다항회귀식의 R-squared값과 비슷해지는 것을 알 수 있다. 차수가 2, 3일때는 과적합이 크게 나타나지 않아 Ridge회귀와 Lasso회귀를 적용했을 때 크게 개선이 없다. 하지만 차수가 4인 경우, 적절한 alpha값으로 규제를 가하면 train set과 test set의 차이를 줄일 수 있다. 즉 과적합을 줄여 test set에 대한 설명력을 높일 수 있는 것이다. Degree=4일 때의 Ridge와 Lasso는 실행속도의 한계로 생략하였다. 위와 같이 하이퍼파라미터 조정을 거쳐, Ridge회귀와 Lasso회귀의 alpha값은 0.005로 설정하여 모델링하였다. 또한 차수는 3으로 설정하였으며, 다항회귀와 Lasso보다 더 좋은 성능을 보였던 Ridge회귀만을 사용하였다. 수온 변수를 예측하였을 때, 다항회귀의 R-squared값은 80.2, Ridge회귀의 R-squared값은 80.3이었다. 

## 성능 비교표
![image](https://user-images.githubusercontent.com/80387630/121210204-71931600-c8b6-11eb-8581-09b30cc9a15f.png)

[Modeling④ - 각 기법의 성능 비교표]


## 결론 및 시사점 
  본 과제는 제공되는 과거의 날씨, 하천의 정보를 통해서 현재 제공되고 있지 않은 미래의 하천의 수온과 같은 값을 직접 측정하지 않고 예측할 수 있다는 점에서 큰 의의를 가진다. 실제로, 미래의 일은 직접 측정하지 않으면 알 수 없는 경우가 대부분이다. 하지만 짧은 미래의 일을 예측해주는 곳이 있다. 바로 기상청이다. 과거 데이터를 바탕으로 날씨와 수온, 수심 등의 관련성에 대해 모델을 학습시킨 후, 기상청의 데이터를 토대로 날씨 데이터를 이용한다면 미래의 하천의 수온, 수심, 유속 등을 예측할 수 있겠다는 생각에서 본 과제는 시작되었다.  DNN, LSTM, 릿지 라쏘 회귀, 단순 선형회귀 등의 기법을 사용하여 분석을 진행하였고 변수별로 가장 RMSE 및 R_square 값이 가장 우수한 모델을 이용하는 방향을 택했다. 또한 종합 레저 지수를 생성하기 위해 실제 레저를 즐기는 사람들의 목소리를 들어보기로 하였다. 따라서 레저별 네이버 카페를 텍스트마이닝 하여 본 과제에서 추출한 변수들의 가중치를 정하여 최종 레저 지수를 완성할 수 있었다. 


