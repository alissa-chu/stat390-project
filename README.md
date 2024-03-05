# Time series modeling

This is the Stat 390 Data Science Capstone final project repository for our team.

# Introduction

Our objective is to analyze COVID-19 vaccination data in order to predict COVID-19 death rates within 4 US regions: East, Midwest, South, and West. Though we used the same vaccination data for univariate and multivariate models, our death data had a different temporal focus for the two. For our univariate models, our death data was daily. For our multivariate models, our death data was weekly. 

Through this initiative, we hope to provide a robust analysis of the relationship between vaccination rates and death and assist vaccine manufacturers, health professionals, and government officials to prevent future COVID-19 deaths.

# Data

Our original data sources are the Centers for Disease Control and Prevention and the NYTIMES Coronavirus (Covid-19) Stats for the United States. Our original vaccination data and weekly death data come from the CDC while our daily death data comes from the NYTIMES Coronavirus (Covid-19) Stats for the United States (found on Kaggle.) Our multivariate time series models required data preparation. We cleaned the weekly death and vaccine datasets separately before merging the two together and cleaning further. This is the dataset we will use in this project for our multivariate models. For our univariate models, we split our daily death dataset into 4 datasets per our 4 regions of focus: East, Midwest, South, and West. These datasets: `east_daily`, `midwest_daily`, `south_daily`, and `west_daily` will be used for our univariate models and consist of a date column and a daily deaths column. We did not use our weekly death dataset for these models because there were too few observations per region.

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
</td><td>

| Tables        | Are           | Cool  |
| ------------- |:-------------:| -----:|
| col 3 is      | right-aligned | $1600 |
| col 2 is      | centered      |   $12 |
| zebra stripes | are neat      |    $1 |


| Tables        | Are           | Cool  |
| ------------- |:-------------:| -----:|
| col 3 is      | right-aligned | $1600 |
| col 2 is      | centered      |   $12 |
| zebra stripes | are neat      |    $1 |


| Tables        | Are           | Cool  |
| ------------- |:-------------:| -----:|
| col 3 is      | right-aligned | $1600 |
| col 2 is      | centered      |   $12 |
| zebra stripes | are neat      |    $1 |


## Auto ARIMA / SARIMA

AutoARIMA is an extension of the ARIMA model that automates the process of selecting the arima model values p, d, and q. It uses a search algorithm to explore different combinations of these parameters and selects a model that minimizes AIC. SARIMA or Seasonal ARIMA is formed by including additional seasonal terms in the ARIMA models in addition to the non-seasonal orders. A seasonal pattern exists when a series is influenced by seasonal factors. Seasonality is always of a fixed and known period. In the model, we use uppercase notation for the seasonal parts of the model. 

Auto ARIMA / SARIMA Model Performance by Region:

## Prophet

Prophet is a forecasting model developed by Facebook that is user-friendly and suitable for a wide range of time series forecasting applications. Prophet is well suited for datasets with missing data points, outliers, and irregular patterns. It decomposes time series data into three components: seasonality, holidays, and trend. Prophet incorporates both yearly and weekly seasonality by default. Prophet allows the incorporation of holiday effects, including allowing users to specify holidays. Finally, prophet models the overall trend in the data, including both linear and non-linear components. 

Univariate Prophet Model Performance by Region:

Multivariate Prophet Model Performance:

## XGBoost

XGBoost, short for eXtreme Gradient Boosting, is a powerful and versatile machine learning algorithm that builds an ensemble of decision trees. It has become widely popular in data science competitions and real-world applications due to its efficiency, scalability, and performance. It can be applied to time series forecasting by treating it as a supervised learning problem, where the time series data includes time lags as features. 

XGBoost Model Performance:

# Model Performance Comparison



# Caveats and Remarks

In the context of our project, it's important to consider the following for conducting reliable a time series analysis

1. The models we provided, however well performing they might be, may not be fully tuned to their optimal extent, which means the results obtained should not be taken as complete conclusive findings. Further optimization can potentially achieve even better results and even more conclusive results.
2. It is worth noting that some models may require less fine-tuning to yield reasonably good results. In particular, we found that our Prophet and XGBoost models required less fine-tuning than our ARIMA models, making them attractive choices when time or resources are limited.
3. When working with time series models, it is important to avoid the leakage of future information. To maintain integrity we proceeded with the following:

   a). We used lagged features and rolling window statistics to capture past patterns and dependencies in the time series data.
