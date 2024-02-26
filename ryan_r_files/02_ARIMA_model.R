## ARIMA Model

# Load Necessary Files -----------------------------------------------------
library(forecast)
library(tseries)
library(tidyverse)
library(kableExtra)

set.seed(123)

## Load the Datasets
load("data/east_uni.rda")
load("data/midwest_uni.rda")
load("data/south_uni.rda")
load("data/west_uni.rda")

# Building ARIMA Model ---------------------------------------------------------
east_arima <- arima(east_train_ts, order=c(1,0,2))
midwest_arima <- arima(midwest_train_ts, order=c(2,1,1))
south_arima <- arima(south_train_ts, order=c(8,1,3))
west_arima <- arima(west_train_ts, order=c(3,1,1))
                      
## Summary & Forecast ---------------------------------------------------------
summary(east_arima)
summary(midwest_arima)
summary(south_arima)
summary(west_arima)

east_values <- forecast(east_arima, h = length(east_test_ts))
midwest_values <- forecast(midwest_arima, h = length(midwest_test_ts))
south_values <- forecast(south_arima, h = length(south_test_ts))
west_values <- forecast(west_arima, h = length(west_test_ts))

# Print the forecasted values
print(east_values)
print(midwest_values)
print(south_values)
print(west_values)

## Evaluating Accuracy ---------------------------------------------------------
accuracy(east_values) %>% 
  kbl() %>% 
  kable_minimal()
accuracy(midwest_values) %>% 
  kbl() %>% 
  kable_minimal()
accuracy(south_values) %>% 
  kbl() %>% 
  kable_minimal()
accuracy(west_values) %>% 
  kbl() %>% 
  kable_minimal()

# Grid Search for p and q ------------------------------------------------------

p_values <- 0:5  # AR order
d_values <- 0:1  # I order
q_values <- 0:5  # MA order

## East - Perform grid search for ARIMA parameters  ----------------------------
best_east_model <- NULL
best_east_aic <- Inf

for (p in p_values) {
  for (d in d_values) {
    for (q in q_values) {
      # Fit ARIMA model
      arima_model <- tryCatch(
        {
          fit <- Arima(east_ts, order = c(p, d, q))
          fit
        },
        error = function(e) {
          NULL
        }
      )
      
      # Check if ARIMA model was successfully fitted
      if (!is.null(arima_model)) {
        # Check AIC criterion
        if (AIC(arima_model) < best_east_aic) {
          best_east_model <- arima_model
          best_east_aic <- AIC(arima_model)
          best_east_order <- c(p, d, q)
        }
      }
    }
  }
}

# Display the best ARIMA model and its parameters
print(paste("Best East ARIMA model (p, d, q):", best_east_order))
print(best_east_model)

## Midwest - Perform grid search for ARIMA parameters  -------------------------
best_midwest_model <- NULL
best_midwest_aic <- Inf

for (p in p_values) {
  for (d in d_values) {
    for (q in q_values) {
      # Fit ARIMA model
      arima_model <- tryCatch(
        {
          fit <- Arima(midwest_ts, order = c(p, d, q))
          fit
        },
        error = function(e) {
          NULL
        }
      )
      
      # Check if ARIMA model was successfully fitted
      if (!is.null(arima_model)) {
        # Check AIC criterion
        if (AIC(arima_model) < best_midwest_aic) {
          best_midwest_model <- arima_model
          best_midwest_aic <- AIC(arima_model)
          best_midwest_order <- c(p, d, q)
        }
      }
    }
  }
}

# Display the best ARIMA model and its parameters
print(paste("Best Midwest ARIMA model (p, d, q):", best_midwest_order))
print(best_midwest_model)

## South - Perform grid search for ARIMA parameters  ---------------------------
best_south_model <- NULL
best_south_aic <- Inf

for (p in p_values) {
  for (d in d_values) {
    for (q in q_values) {
      # Fit ARIMA model
      arima_model <- tryCatch(
        {
          fit <- Arima(south_ts, order = c(p, d, q))
          fit
        },
        error = function(e) {
          NULL
        }
      )
      
      # Check if ARIMA model was successfully fitted
      if (!is.null(arima_model)) {
        # Check AIC criterion
        if (AIC(arima_model) < best_south_aic) {
          best_south_model <- arima_model
          best_south_aic <- AIC(arima_model)
          best_south_order <- c(p, d, q)
        }
      }
    }
  }
}

# Display the best ARIMA model and its parameters
print(paste("Best South ARIMA model (p, d, q):", best_south_order))
print(best_south_model)

## West - Perform grid search for ARIMA parameters  ----------------------------
best_west_model <- NULL
best_west_aic <- Inf

for (p in p_values) {
  for (d in d_values) {
    for (q in q_values) {
      # Fit ARIMA model
      arima_model <- tryCatch(
        {
          fit <- Arima(west_ts, order = c(p, d, q))
          fit
        },
        error = function(e) {
          NULL
        }
      )
      
      # Check if ARIMA model was successfully fitted
      if (!is.null(arima_model)) {
        # Check AIC criterion
        if (AIC(arima_model) < best_west_aic) {
          best_west_model <- arima_model
          best_west_aic <- AIC(arima_model)
          best_west_order <- c(p, d, q)
        }
      }
    }
  }
}

# Display the best ARIMA model and its parameters
print(paste("Best West ARIMA model (p, d, q):", best_west_order))
print(best_west_model)

