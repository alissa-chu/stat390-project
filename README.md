# Time series modeling

# Introduction

Our objective is to analyze COVID-19 vaccination data in order to predict COVID-19 death rates within 4 US regions: East, Midwest, South, and West. Though we used the same vaccination data for univariate and multivariate models, our death data had a different temporal focus for the two. For our univariate models, our death data was daily. We sought to predict daily COVID-19 death rates with three univariate models: ARIMA, auto-ARIMA/SARIMA, and Prophet. For our multivariate models, our death data was weekly. We sought to predict weekly COVID-19 death rates with two multivariate models: Prophet nad XGBoost.
Through this initiative, we hope to provide a robust analysis of the relationship between vaccination rates and death and assist vaccine manufacturers, health professionals, and government officials to prevent future COVID-19 deaths.

# Data

Our original data sources are the Centers for Disease Control and Prevention and the NYTIMES Coronavirus (Covid-19) Stats for the United States. Our original vaccination data and weekly death data come from the CDC while our daily death data comes from the NYTIMES Coronavirus (Covid-19) Stats for the United States (found on Kaggle.) Our multivariate time series models required data preparation. We cleaned the weekly death and vaccine datasets separately before merging the two together and cleaning further. This is the dataset we will use in this project for our multivariate models. For our univariate models, 
we split our daily death dataset into 4 datasets per our 4 regions of focus: East, Midwest, South, and West. These datasets: east_daily, midwest_daily, south_daily, and west_daily will be used foro ur univariate models and consist of a date column and a daily deaths column.
