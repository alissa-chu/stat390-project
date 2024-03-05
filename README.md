# Time series modeling

This is the Stat 390 Data Science Capstone final project repository for our team.

# Introduction

Our objective is to analyze COVID-19 vaccination data in order to predict COVID-19 death rates within 4 US regions: East, Midwest, South, and West. Though we used the same vaccination data for univariate and multivariate models, our death data had a different temporal focus for the two. For our univariate models, our death data was daily. For our multivariate models, our death data was weekly. 

Through this initiative, we hope to provide a robust analysis of the relationship between vaccination rates and death and assist vaccine manufacturers, health professionals, and government officials to prevent future COVID-19 deaths.

# Data

Our original data sources are the Centers for Disease Control and Prevention and the NYTIMES Coronavirus (Covid-19) Stats for the United States. Our original vaccination data and weekly death data come from the CDC while our daily death data comes from the NYTIMES Coronavirus (Covid-19) Stats for the United States (found on Kaggle.) Our multivariate time series models required data preparation. We cleaned the weekly death and vaccine datasets separately before merging the two together and cleaning further. This is the dataset we will use in this project for our multivariate models. For our univariate models, we split our daily death dataset into 4 datasets per our 4 regions of focus: East, Midwest, South, and West. These datasets: `east_daily`, `midwest_daily`, `south_daily`, and `west_daily` will be used for our univariate models and consist of a date column and a daily deaths column. We did not use our weekly death dataset for these models because there were too few observations per region (the maximum number of rows we could have with weekly data was only around 200). Our final datasets had 1136 rows for our univariate models and 7306 rows and 91 columns for our multivariate models.

# Models

The models in this project are:
- ARIMA
- Auto ARIMA/SARIMA
- Prophet univariate
- Prophet multivariate
- XGBoost

## ARIMA (AutoRegressive Integrated Moving Average)

ARIMA is a widely used method for times series forecasting. It is a powerful and flexible model that can capture various patterns and trends in time series data. Its models have three key components:
- AutoRegressive (AR): it captures the relationship between an observation and several lagged observations, indicating that the model can use its own past values to predict future values.
- Integrated (I): it represents the differencing of the time series data to make it stationary, stabilizing the mean and variance and helping to remove trends and seasonality.
- Moving Average (MA): accounts for the relationship between an observation and a weighted average of past prediction errors

ARIMA Model Performance by Region:

| East Region      | MAE          | MASE  |   
| ------------- |-------------| -----|
| Alissa      |  59.725 |  0.674 |
| Emily      | 57.1463      |  0.5981 |
| Nishi | 48.453     |  0.622 |
| Ryan | 47.188     |   0.724 |

| Midwest Region      | MAE          | MASE  |   
| ------------- |-------------| -----|
| Alissa      |   60.029 |  0.541 |
| Emily      | 61.101     |  0.532 |
| Nishi |125.948   |  0.565 |
| Ryan | 54.436  |  0.515|

| South Region      | MAE          | MASE  |   
| ------------- |-------------| -----|
| Alissa      |   91.638 |   0.573 |
| Emily      | 135.654      |  0.628 |
| Nishi | 131.212    |  0.530|
| Ryan | 94.708   |   0.548|

| West Region      | MAE          | MASE  |   
| ------------- |-------------| -----|
| Alissa      |  36.165|  0.451 |
| Emily      | 37.028    |  0.449|
| Nishi | 72.550   | 0.616|
| Ryan | 46.880   |  0.594 |

## Auto ARIMA / SARIMA

AutoARIMA is an extension of the ARIMA model that automates the process of selecting the arima model values p, d, and q. It uses a search algorithm to explore different combinations of these parameters and selects a model that minimizes AIC. SARIMA or Seasonal ARIMA is formed by including additional seasonal terms in the ARIMA models in addition to the non-seasonal orders. A seasonal pattern exists when a series is influenced by seasonal factors. Seasonality is always of a fixed and known period. In the model, we use uppercase notation for the seasonal parts of the model. 

Auto ARIMA / SARIMA Model Performance by Region:

| East Region      | MAE          | MASE  |   
| ------------- |-------------| -----|
| Alissa      |  52.947 |   0.597|
| Emily      | 50.0504     | 0.565 |
| Nishi | 73.042   | 0.622 |
| Ryan | 46.104    |  0.716|

| Midwest Region      | MAE          | MASE  |   
| ------------- |-------------| -----|
| Alissa      |  52.602 |    0.474|
| Emily      | 52.955   |0.477 |
| Nishi | 84.702 | 0.565 |
| Ryan | 47.448   |  0.435|

| South Region      | MAE          | MASE  |   
| ------------- |-------------| -----|
| Alissa      |  85.775 | 0.536|
| Emily      | 98.629   |0.510|
| Nishi | 147.473| 0.533 |
| Ryan |85.738  | 0.496|

| West Region      | MAE          | MASE  |   
| ------------- |-------------| -----|
| Alissa      |  29.869|  0.373|
| Emily      | 33.100   |0.417|
| Nishi | 69.751| 0.616 |
| Ryan |36.964 |0.456|

## Prophet

Prophet is a forecasting model developed by Facebook that is user-friendly and suitable for a wide range of time series forecasting applications. Prophet is well suited for datasets with missing data points, outliers, and irregular patterns. It decomposes time series data into three components: seasonality, holidays, and trend. Prophet incorporates both yearly and weekly seasonality by default. Prophet allows the incorporation of holiday effects, including allowing users to specify holidays. Finally, prophet models the overall trend in the data, including both linear and non-linear components. 

Univariate Prophet Model Performance by Region:

| East Region      | MAE          | MASE  |   
| ------------- |-------------| -----|
| Alissa      |  42.219 |  0.476|
| Emily      | 57.2004    | 0.5987|
| Nishi | 66.281| 0.9994 |
| Ryan | 64.132  | 0.724|

| Midwest Region      | MAE          | MASE  |   
| ------------- |-------------| -----|
| Alissa      |  51.291 |  0.443|
| Emily      | 71.0213 | 0.607|
| Nishi | 110.562| 1.001|
| Ryan | 92.441 | 0.798|

| South Region      | MAE          | MASE  |   
| ------------- |-------------| -----|
| Alissa      |  105.05 |  0.543|
| Emily      | 132.388 | 0.612|
| Nishi | 157.526|0.999|
| Ryan | 173.927| 0.899|

| West Region      | MAE          | MASE  |   
| ------------- |-------------| -----|
| Alissa      |   42.053 |  0.470|
| Emily      | 68.016 | 0.733|
| Nishi | 76.569|1.009|
| Ryan | 74.746| 0.835|

Multivariate Prophet Model Performance:

|     | MAE          | MASE  |   
| ------------- |-------------| -----|
| Alissa      |   49.972 |  0.818|
| Emily      | 66.842 | 0.0266|
| Nishi |77.815|0.0215|
| Ryan | 35.980 | 0.589|


## XGBoost

XGBoost, short for eXtreme Gradient Boosting, is a powerful and versatile machine learning algorithm that builds an ensemble of decision trees. It has become widely popular in data science competitions and real-world applications due to its efficiency, scalability, and performance. It can be applied to time series forecasting by treating it as a supervised learning problem, where the time series data includes time lags as features. 

XGBoost Model Performance:

|     | MAE          | MASE  |   
| ------------- |-------------| -----|
| Alissa      |    16.199|  0.00687|
| Emily      | 17.633 | 0.00748|
| Nishi |18.736|0.00794|
| Ryan |16.838 | 0.00745|

# Model Performance Comparison

## Univariate Models Key Findings

Best models by region: East: Prophet, Midwest: Prophet, South: SARIMA, West: SARIMA

Because there is a seasonality component to our data, the Prophet and SARIMA models performed better than the ARIMA model. Additionally, we chose SARIMA over Auto ARIMA. SARIMA is specifically designed to handle seasonal time series data. Since we know from our PACF and ACF graphs that there is seasonality in our data, SARIMA is potentially more accurate and interpretable. Additionally, SARIMA may provide a better means of finding the optimal parameters. SARIMA grid search is exhaustive: grid search exhaustively tests combinations within these specified ranges. Auto ARIMA search is stepwise: with the iterative and stepwise nature of auto arima it may not be as adept as SARIMA at finding the optimal parameters

Next, We found that setting yearly_seasonality = False worked better for our univariate prophets. If we included yearly_seasonality, our model overfit to the spikes in deaths in January 2021 and 2022 in our train data. Without including external factors such as vaccines, this led to the model predicting a spike in January 2023 in our test data that did not exist in the actual values.

## Multivariate Models Key Findings

For the Multivariate Prophet model, setting both Yearly and Weekly Seasonality = TRUE as well as adding holidays and regressors helped the model performance. 

However, XGBoost was the best multivariate model. The most important features found from the feature importance of the model were: mmwr_week, lag / date features (half year, one year), additional doses, and distributed doses. First, The Morbidity and Mortality Weekly Report (Mmwr_week) was an important feature because it provides accurate and timely information on the mortality rate. We also added lag and rolling window statistic using half year, year, year and a half, and two years as our lags/windows. This was based on our ACF which showed appropriate graph spikes around 26 weeks, 52 weeks, 78 weeks, and 104 weeks. Lastly, adding the additional doses and distributed doses improved the XGBoost model because it provided an accurate count of deaths since the vaccine distribution was significant in improving mortality rates. 

The overall best model was XGBoost with MAE of 16.199 and MASE of 0.00687.

# Caveats and Remarks

In the context of our project, it's important to consider the following for conducting reliable a time series analysis

1. The models we provided, however well performing they might be, may not be fully tuned to their optimal extent, which means the results obtained should not be taken as complete conclusive findings. Further optimization can potentially achieve even better results and even more conclusive results.
2. It is worth noting that some models may require less fine-tuning to yield reasonably good results. In particular, we found that our Prophet and XGBoost models required less fine-tuning than our ARIMA models, making them attractive choices when time or resources are limited.
3. When working with time series models, it is important to avoid the leakage of future information. To maintain integrity we proceeded with the following:

   a). We used lagged features and rolling window statistics to capture past patterns and dependencies in the time series data.
