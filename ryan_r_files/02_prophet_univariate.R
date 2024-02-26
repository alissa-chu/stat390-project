# Prophet Model

# Load Necessary Files ---------------------------------------------------------
library(forecast)
library(tseries)
library(tidyverse)
library(tidymodels)
library(kableExtra)
library(modeltime)
library(prophet)
library(timetk)

set.seed(123)

# Loading Data  ----------------------------------------------------------------

## Converting it into Prophet format
total <- read_csv("data/new_daily_deaths.csv") %>% 
  rename(ds = date,
         y = daily_deaths) %>% 
  select(-c(region)) %>% 
  group_by(ds) %>% 
  mutate(y = sum(y)) %>% 
  distinct(ds, y)

east <- read_csv("data/east_daily.csv") %>% 
  rename(ds = date,
         y = daily_deaths)

midwest <- read_csv("data/midwest_daily.csv") %>% 
  rename(ds = date,
         y = daily_deaths)

south <- read_csv("data/south_daily.csv") %>% 
  rename(ds = date,
         y = daily_deaths)

west <- read_csv("data/west_daily.csv") %>% 
  rename(ds = date,
         y = daily_deaths)

# Data Splitting ---------------------------------------------------------------
total_splits <- time_series_split(total, initial = "908 days", assess = "228 days")
total_train <- training(total_splits)
total_test <- testing(total_splits)

east_splits <- time_series_split(east, initial = "1022 days", assess = "114 days")
east_train <- training(east_splits)
east_test <- testing(east_splits)

midwest_splits <- time_series_split(midwest, initial = "908 days", assess = "228 days")
midwest_train <- training(midwest_splits)
midwest_test <- testing(midwest_splits)

south_splits <- time_series_split(south, initial = "908 days", assess = "228 days")
south_train <- training(south_splits)
south_test <- testing(south_splits)

west_splits <- time_series_split(west, initial = "908 days", assess = "228 days")
west_train <- training(west_splits)
west_test <- testing(west_splits)

# Building Prophet Models ------------------------------------------------------

## Total -----------------------------------------------------------------------
### Initialize & Fit the Prophet ----
total_prophet <- prophet(total_train)
total_fit <- fit.prophet(total_prophet, total_train) # running into errors

### Forecast Future Predictions ----
total_future <- make_future_dataframe(total_prophet, periods = 208, freq = "day")
total_forecast <- predict(total_prophet, total_future)


## East Region -----------------------------------------------------------------
### Initialize & Fit the Prophet ----
east_prophet <- prophet(east_train)

### Forecast Future Predictions ----
east_future <- make_future_dataframe(east_prophet, periods = nrow(east_test), freq = "day")
east_forecast <- predict(east_prophet, east_future)

east_mae <- mean(abs(east_test$y - east_forecast$yhat))
print(paste("Mean Absolute Error (MAE):", east_mae))

## Midwest Region --------------------------------------------------------------
### Initialize & Fit the Prophet ----
midwest_prophet <- prophet(midwest_train)
midwest_fit <- fit.prophet(midwest_prophet, midwest_train) # running into errors

### Forecast Future Predictions ----
midwest_future <- make_future_dataframe(midwest_prophet, periods = nrow(midwest_test), freq = "day")
midwest_forecast <- predict(midwest_prophet, midwest_future)


## South Region -----------------------------------------------------------------
### Initialize & Fit the Prophet ----
south_prophet <- prophet(south_train)
south_fit <- fit.prophet(south_prophet, south_train) # running into errors

### Forecast Future Predictions ----
south_future <- make_future_dataframe(south_prophet, periods = nrow(south_test), freq = "day")
south_forecast <- predict(south_prophet, south_future)


## West Region -----------------------------------------------------------------
### Initialize & Fit the Prophet ----
west_prophet <- prophet(west_train)
west_fit <- fit.prophet(west_prophet, west_train) # running into errors

### Forecast Future Predictions ----
west_future <- make_future_dataframe(west_prophet, periods = nrow(west_test), freq = "day")
west_forecast <- predict(west_prophet, west_future)


# Plotting Forecasts -----------------------------------------------------------
plot(total_prophet, total_forecast) +
  geom_point(data = total_test, aes(x = as.POSIXct.Date(ds), y = y), alpha = 0.2) +
  theme_minimal() +
  labs(title = "Total Univariate Prophet",
       x = "Date",
       y = "Daily Deaths")

plot(east_prophet, east_forecast) +
  theme_minimal() +
  labs(title = "East Univariate Prophet",
       x = "Date",
       y = "Daily Deaths")

plot(midwest_prophet, midwest_forecast) +
  theme_minimal() +
  labs(title = "Midwest Univariate Prophet",
       x = "Date",
       y = "Daily Deaths")

plot(south_prophet, south_forecast) +
  theme_minimal() +
  labs(title = "South Univariate Prophet",
       x = "Date",
       y = "Daily Deaths")

plot(west_prophet, west_forecast) +
  theme_minimal() +
  labs(title = "West Univariate Prophet",
       x = "Date",
       y = "Daily Deaths")

# Model Accuracy ---------------------------------------------------------------

## Total Prophet ----------------------------------------------------------------
total_mae <- mean(abs(total_test$y - total_forecast$yhat))
print(paste("Mean Absolute Error (MAE):", total_mae))

total_rmse <- sqrt(mean((total_test$y - total_forecast$yhat)^2))
print(paste("RMSE:", total_rmse))


## East Prophet ----------------------------------------------------------------
east_mae <- mean(abs(east_test$y - east_forecast$yhat))
print(paste("Mean Absolute Error (MAE):", east_mae))

east_rmse <- sqrt(mean((east_test$y - east_forecast$yhat)^2))
print(paste("RMSE:", east_rmse))


## Midwest Prophet -------------------------------------------------------------
midwest_mae <- mean(abs(midwest_test$y - midwest_forecast$yhat))
print(paste("Mean Absolute Error (MAE):", midwest_mae))

midwest_rmse <- sqrt(mean((midwest_test$y - midwest_forecast$yhat)^2))
print(paste("RMSE:", midwest_rmse))


## South Prophet ----------------------------------------------------------------
south_mae <- mean(abs(south_test$y - south_forecast$yhat))
print(paste("Mean Absolute Error (MAE):", south_mae))

south_rmse <- sqrt(mean((south_test$y - south_forecast$yhat)^2))
print(paste("RMSE:", south_rmse))


## West Prophet ----------------------------------------------------------------
west_mae <- mean(abs(west_test$y - west_forecast$yhat))
print(paste("Mean Absolute Error (MAE):", west_mae))

west_rmse <- sqrt(mean((west_test$y - west_forecast$yhat)^2))
print(paste("RMSE:", west_rmse))

