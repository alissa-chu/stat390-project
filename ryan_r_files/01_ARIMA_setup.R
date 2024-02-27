## initial set ups

# Load necessary libraries
library(forecast)
library(tseries)
library(tidyverse)
library(tidymodels)
library(kableExtra)
library(modeltime)
library(timetk)

# setting the seed
set.seed(123)

# Loading Data  ----------------------------------------------------------------
east <- read_csv("data/east_daily.csv")

midwest <- read_csv("data/midwest_daily.csv")

south <- read_csv("data/south_daily.csv")

west <- read_csv("data/west_daily.csv")

# Data Splitting ---------------------------------------------------------------
east_splits <- time_series_split(east, initial = "908 days", assess = "228 days")
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

## Plotting Training and Testing -----------------------------------------------
ggplot() +
  geom_line(data = east_test, aes(x = date, y = daily_deaths), color = "turquoise") +
  geom_point(data = east_test, aes(x = date, y = daily_deaths), color = "turquoise", size = .5) +
  geom_line(data = east_train, aes(x = date, y = daily_deaths), color = "orange") +
  geom_point(data = east_train, aes(x = date, y = daily_deaths), color = "orange", size = .5) +
  labs(x = "daily deaths",
       title = "East Region Training vs. Testing Data") +
  scale

ggplot() +
  geom_line(data = midwest_test, aes(x = date, y = daily_deaths), color = "turquoise") +
  geom_point(data = midwest_test, aes(x = date, y = daily_deaths), color = "turquoise", size = .5) +
  geom_line(data = midwest_train, aes(x = date, y = daily_deaths), color = "orange") +
  geom_point(data = midwest_train, aes(x = date, y = daily_deaths), color = "orange", size = .5) +
  labs(x = "daily deaths",
       title = "Midwest Region Training vs. Testing Data")

ggplot() +
  geom_line(data = south_test, aes(x = date, y = daily_deaths), color = "turquoise") +
  geom_point(data = south_test, aes(x = date, y = daily_deaths), color = "turquoise", size = .5) +
  geom_line(data = south_train, aes(x = date, y = daily_deaths), color = "orange") +
  geom_point(data = south_train, aes(x = date, y = daily_deaths), color = "orange", size = .5) +
  labs(x = "daily deaths",
       title = "South Region Training vs. Testing Data")

ggplot() +
  geom_line(data = west_test, aes(x = date, y = daily_deaths), color = "turquoise") +
  geom_point(data = west_test, aes(x = date, y = daily_deaths), color = "turquoise", size = .5) +
  geom_line(data = west_train, aes(x = date, y = daily_deaths), color = "orange") +
  geom_point(data = west_train, aes(x = date, y = daily_deaths), color = "orange", size = .5) +
  labs(x = "daily deaths",
       title = "West Region Training vs. Testing Data")


## Creating Folds --------------------------------------------------------------

east_folds <- time_series_cv(east,
                             date_var = date,
                             initial = "908 days",
                             asssess = "228 days")

midwest_folds <- time_series_cv(midwest,
                             date_var = date,
                             initial = "908 days",
                             asssess = "228 days")

south_folds <- time_series_cv(south,
                             date_var = date,
                             initial = "908 days",
                             asssess = "228 days")

west_folds <- time_series_cv(west,
                             date_var = date,
                             initial = "908 days",
                             asssess = "228 days")

# ARIMA Set-Up -----------------------------------------------------------------

## Convert Into Time Series ----------------------------------------------------
east_train_ts <- ts(east_train %>%
                      select(daily_deaths))
east_test_ts <- ts(east_test %>%
                     select(daily_deaths))
east_ts <- ts(east %>% 
                select(daily_deaths))

midwest_train_ts <- ts(midwest_train %>%
                      select(daily_deaths))
midwest_test_ts <- ts(midwest_test %>%
                     select(daily_deaths))
midwest_ts <- ts(midwest %>% 
                select(daily_deaths))

south_train_ts <- ts(south_train %>%
                    select(daily_deaths))
south_test_ts <- ts(south_test %>%
                   select(daily_deaths))
south_ts <- ts(south %>%
                 select(daily_deaths))

west_train_ts <- ts(west_train %>%
                   select(daily_deaths))
west_test_ts <- ts(west_test %>%
                  select(daily_deaths))
west_ts <- ts(west %>%
                select(daily_deaths))

## Stationarity Testing --------------------------------------------------------

### Using Augmented Dickey-Fuller Test -----------------------------------------
adf_east <- adf.test(east_ts)
print(adf_east) # p-value is 0.01 < 0.05, implying it is stationary

adf_midwest <- adf.test(midwest_ts)
print(adf_midwest) # p-value is 0.4919 > 0.05, implying it is NOT stationary
midwest_ts <- diff(midwest_ts)
adf_midwest <- adf.test(midwest_ts)
print(adf_midwest) # p-value is 0.01 < 0.05, implying it is stationary with 1 diff

adf_south <- adf.test(south_ts)
print(adf_south) # p-value is 0.3018 > 0.05, implying it is NOT stationary
south_ts <- diff(south_ts)
adf_south <- adf.test(south_ts)
print(adf_south) # p-value is 0.01 < 0.05, implying it is stationary with 1 diff

adf_west <- adf.test(west_ts)
print(adf_west) # p-value is 0.4098 > 0.05, implying it is NOT stationary
west_ts <- diff(west_ts)
adf_west <- adf.test(west_ts)
print(adf_west)  # p-value is 0.01 < 0.05, implying it is stationary with 1 diff


### Making Testing/Training Stationary -----------------------------------------
midwest_train_ts <- diff(midwest_train_ts)
midwest_test_ts <- diff(midwest_test_ts)

south_train_ts <- diff(south_train_ts)
south_test_ts <- diff(south_test_ts)

west_train_ts <- diff(west_train_ts)
west_test_ts <- diff(west_test_ts)


## ACF & PACF Plots ------------------------------------------------------------
acf(east_ts, main = "East")
acf(midwest_ts, main = "Midwest")
acf(south_ts, main = "South")
acf(west_ts, main = "West")

pacf(east_ts, main = "East")
pacf(midwest_ts, main = "Midwest")
pacf(south_ts, main = "South")
pacf(west_ts, main = "West")

### Plot Time Series Data ------------------------------------------------------
plot(east_ts, main = "Daily Deaths: East")
plot(midwest_ts, main = "Daily Deaths: Midwest")
plot(south_ts, main = "Daily Deaths: South")
plot(west_ts, main = "Daily Deaths: West")

## Saving Data for Model Building ----------------------------------------------
save(east_folds, east_train_ts, east_test_ts, east_train, east_test, east_ts, 
     file = "data/east_uni.rda")

save(midwest_folds, midwest_train_ts, midwest_test_ts, midwest_train, midwest_test, midwest_ts, 
     file = "data/midwest_uni.rda")

save(south_folds, south_train_ts, south_test_ts, south_train, south_test, south_ts, 
     file = "data/south_uni.rda")

save(west_folds, west_train_ts, west_test_ts, west_train, west_test, west_ts, 
     file = "data/west_uni.rda")

