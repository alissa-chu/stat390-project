## SARIMA Model

# Load Necessary Files ---------------------------------------------------------
library(forecast)
library(tseries)
library(tidyverse)
library(tidymodels)
library(kableExtra)
library(modeltime)
library(timetk)

set.seed(123)

## Load the Datasets 
load("data/east_uni.rda")
load("data/midwest_uni.rda")
load("data/south_uni.rda")
load("data/west_uni.rda")

# Building SARIMA model  ------------------------------------------------------
east_sarima <- arima(east_train_ts, seasonal = list(order = c(1,1,1)))
midwest_sarima <- arima(midwest_train_ts, seasonal = list(order = c(1,1,1)))
south_sarima <- arima(south_train_ts, seasonal = list(order = c(1,1,1)))
west_sarima <- arima(west_train_ts, seasonal = list(order = c(1,1,1)))

# Summary of the SARIMA model
summary(east_sarima)
summary(midwest_sarima)
summary(south_sarima)
summary(west_sarima)

## Forecasting with the SARIMA model -------------------------------------------
east_values <- forecast(east_sarima, h = length(east_test_ts))
midwest_values <- forecast(midwest_sarima, h = length(midwest_test_ts))
south_values <- forecast(south_sarima, h = length(south_test_ts))
west_values <- forecast(west_sarima, h = length(west_test_ts))

# Print the forecasted values
print(east_values)
print(midwest_values)
print(south_values)
print(west_values)

## Plotting Forecasted vs. Actual Values ----------------------------------------
### East Region
east_test_plot <- as.data.frame(east_test_ts) %>% 
  mutate(num = seq(909, (909+227)))

east_initial_sarima_plot <- forecast::autoplot(east_values) +
  geom_line(data = east_test_plot, aes(x = num, y = daily_deaths)) +
  scale_x_continuous(
    breaks = c(0, 300, 600 , 900),
    labels = c("Feb 2020", "Dec 2020", "Oct 2021", "July 2022")
  ) +
  labs(title = "East Region Initial SARIMA",
       y = "Daily Deaths") 


### Midwest Region
midwest_test_plot <- as.data.frame(midwest_test_ts) %>% 
  mutate(num = seq(909, (909+226)))

midwest_initial_sarima_plot <- forecast::autoplot(midwest_values) +
  geom_line(data = midwest_test_plot, aes(x = num, y = daily_deaths)) +
  scale_x_continuous(
    breaks = c(0, 300, 600 , 900),
    labels = c("Feb 2020", "Dec 2020", "Oct 2021", "July 2022")
  ) +
  labs(title = "Midwest Region Initial SARIMA",
       y = "Daily Deaths")


### South Region
south_test_plot <- as.data.frame(south_test_ts) %>% 
  mutate(num = seq(909, (909+226)))

south_initial_sarima_plot <- forecast::autoplot(south_values) +
  geom_line(data = south_test_plot, aes(x = num, y = daily_deaths)) +
  scale_x_continuous(
    breaks = c(0, 300, 600 , 900),
    labels = c("Feb 2020", "Dec 2020", "Oct 2021", "July 2022")
  ) +
  labs(title = "South Region Initial SARIMA",
       y = "Daily Deaths")


### West Region
west_test_plot <- as.data.frame(west_test_ts) %>% 
  mutate(num = seq(909, (909+226)))

west_initial_sarima_plot <- forecast::autoplot(west_values) +
  geom_line(data = west_test_plot, aes(x = num, y = daily_deaths)) +
  scale_x_continuous(
    breaks = c(0, 300, 600 , 900),
    labels = c("Feb 2020", "Dec 2020", "Oct 2021", "July 2022")
  ) +
  labs(title = "West Region Initial SARIMA",
       y = "Daily Deaths") 


## Evaluate the Accuracy -------------------------------------------------------
east_initial_sarima_acc <- forecast::accuracy(east_values)

midwest_initial_sarima_acc <- forecast::accuracy(midwest_values)

south_initial_sarima_acc <- forecast::accuracy(south_values)

west_initial_sarima_acc <- forecast::accuracy(west_values)

# Grid Search for p, q, P, and Q for SARIMA Models -----------------------------

## Define the parameter grids --------------------------------------------------
p_grid <- 0:5  # AR parameter
d_grid <- 0:1  # Differencing parameter
q_grid <- 0:5  # MA parameter
P_grid <- 0:1  # Seasonal AR parameter
D_grid <- 0:1  # Seasonal differencing parameter
Q_grid <- 0:1  # Seasonal MA parameter
s <- 12        # Seasonal period

## East Grid Search ------------------------------------------------------------

# Create East Region
east_train <- east_train %>% 
  select(daily_deaths)

# Create an empty data frame to store the results
east_results <- data.frame(order = character(),
                      seasonal = character(),
                      AIC = numeric(),
                      stringsAsFactors = FALSE)

# Perform grid search
for (p in p_grid) {
  for (d in d_grid) {
    for (q in q_grid) {
      for (P in P_grid) {
        for (D in D_grid) {
          for (Q in Q_grid) {
            order <- c(p, d, q)
            seasonal <- c(P, D, Q, s)
            model <- tryCatch(
              {
                fit <- arima(east_train, order = order, seasonal = seasonal, method = "ML")
                AIC_val <- AIC(fit)
                # Append the results to the data frame
                east_results <- rbind(east_results, data.frame(order = paste(order, collapse = ", "),
                                                     seasonal = paste(seasonal, collapse = ", "),
                                                     AIC = AIC_val))
              },
              error = function(e) NULL
            )
          }
        }
      }
    }
  }
}

# Print the results
print(east_results)
# Find the best model (minimum AIC)
best_east_model <- east_results[which.min(east_results$AIC), ]
print(best_east_model)



## Midwest Grid Search ------------------------------------------------------------

# Create Midwest Region
midwest_train <- midwest_train %>% 
  select(daily_deaths)

# Create an empty data frame to store the results
midwest_results <- data.frame(order = character(),
                           seasonal = character(),
                           AIC = numeric(),
                           stringsAsFactors = FALSE)

# Perform grid search
for (p in p_grid) {
  for (d in d_grid) {
    for (q in q_grid) {
      for (P in P_grid) {
        for (D in D_grid) {
          for (Q in Q_grid) {
            order <- c(p, d, q)
            seasonal <- c(P, D, Q, s)
            model <- tryCatch(
              {
                fit <- arima(midwest_train, order = order, seasonal = seasonal, method = "ML")
                AIC_val <- AIC(fit)
                # Append the results to the data frame
                midwest_results <- rbind(midwest_results, data.frame(order = paste(order, collapse = ", "),
                                                               seasonal = paste(seasonal, collapse = ", "),
                                                               AIC = AIC_val))
              },
              error = function(e) NULL
            )
          }
        }
      }
    }
  }
}

# Print the results
print(midwest_results)
# Find the best model (minimum AIC)
best_midwest_model <- midwest_results[which.min(midwest_results$AIC), ]
print(best_midwest_model)



## South Grid Search ------------------------------------------------------------

# Create South Region
south_train <- south_train %>% 
  select(daily_deaths)

# Create an empty data frame to store the results
south_results <- data.frame(order = character(),
                           seasonal = character(),
                           AIC = numeric(),
                           stringsAsFactors = FALSE)

# Perform grid search
for (p in p_grid) {
  for (d in d_grid) {
    for (q in q_grid) {
      for (P in P_grid) {
        for (D in D_grid) {
          for (Q in Q_grid) {
            order <- c(p, d, q)
            seasonal <- c(P, D, Q, s)
            model <- tryCatch(
              {
                fit <- arima(south_train, order = order, seasonal = seasonal, method = "ML")
                AIC_val <- AIC(fit)
                # Append the results to the data frame
                south_results <- rbind(south_results, data.frame(order = paste(order, collapse = ", "),
                                                               seasonal = paste(seasonal, collapse = ", "),
                                                               AIC = AIC_val))
              },
              error = function(e) NULL
            )
          }
        }
      }
    }
  }
}

# Print the results
print(south_results)
# Find the best model (minimum AIC)
best_south_model <- south_results[which.min(south_results$AIC), ]
print(best_south_model)




## West Grid Search ------------------------------------------------------------

# Create West Region
west_train <- west_train %>% 
  select(daily_deaths)

# Create an empty data frame to store the results
west_results <- data.frame(order = character(),
                           seasonal = character(),
                           AIC = numeric(),
                           stringsAsFactors = FALSE)

# Perform grid search
for (p in p_grid) {
  for (d in d_grid) {
    for (q in q_grid) {
      for (P in P_grid) {
        for (D in D_grid) {
          for (Q in Q_grid) {
            order <- c(p, d, q)
            seasonal <- c(P, D, Q, s)
            model <- tryCatch(
              {
                fit <- arima(west_train, order = order, seasonal = seasonal, method = "ML")
                AIC_val <- AIC(fit)
                # Append the results to the data frame
                west_results <- rbind(west_results, data.frame(order = paste(order, collapse = ", "),
                                                               seasonal = paste(seasonal, collapse = ", "),
                                                               AIC = AIC_val))
              },
              error = function(e) NULL
            )
          }
        }
      }
    }
  }
}

# Print the results
print(west_results)
# Find the best model (minimum AIC)
best_west_model <- west_results[which.min(west_results$AIC), ]
print(best_west_model)


# Rebuilding SARIMA Models -----------------------------------------------------
east_sarima <- arima(east_train_ts, order = c(5, 1, 4), 
                     seasonal = list(order = c(1, 1, 1), period = 12))
midwest_sarima <- arima(midwest_train_ts, order = c(5, 0, 5),
                        seasonal = list(order = c(0, 1, 0), period = 12))
south_sarima <- arima(south_train_ts, order = c(5, 0, 5),
                           seasonal = list(order = c(0, 1, 0), period = 12))
west_sarima <- arima(west_train_ts, order = c(4, 0, 5),
                     seasonal = list(order = c(1, 1, 1), period = 12))


## Forecasting with the NEW SARIMA model ---------------------------------------
east_values <- forecast(east_sarima, h = length(east_test_ts))
midwest_values <- forecast(midwest_sarima, h = length(midwest_test_ts))
south_values <- forecast(south_sarima, h = length(south_test_ts))
west_values <- forecast(west_sarima, h = length(west_test_ts))


## Evaluate the Accuracy -------------------------------------------------------
east_tuned_sarima_acc <- forecast::accuracy(east_values)

midwest_tuned_sarima_acc <- forecast::accuracy(midwest_values)

south_tuned_sarima_acc <- forecast::accuracy(south_values)

west_tuned_sarima_acc <- forecast::accuracy(west_values)

## New Plots -------------------------------------------------------------------

### East Region
east_test_plot <- as.data.frame(east_test_ts) %>% 
  mutate(num = seq(909, (909+227)))

east_tuned_sarima_plot <- forecast::autoplot(east_values) +
  geom_line(data = east_test_plot, aes(x = num, y = daily_deaths)) +
  scale_x_continuous(
    breaks = c(0, 300, 600 , 900),
    labels = c("Feb 2020", "Dec 2020", "Oct 2021", "July 2022")
  ) +
  labs(title = "East Region SARIMA (5,1,4)(1,1,1)(12)",
       y = "Daily Deaths") 


### Midwest Region
midwest_test_plot <- as.data.frame(midwest_test_ts) %>% 
  mutate(num = seq(909, (909+226)))

midwest_tuned_sarima_plot <- forecast::autoplot(midwest_values) +
  geom_line(data = midwest_test_plot, aes(x = num, y = daily_deaths)) +
  scale_x_continuous(
    breaks = c(0, 300, 600 , 900),
    labels = c("Feb 2020", "Dec 2020", "Oct 2021", "July 2022")
  ) +
  labs(title = "Midwest Region SARIMA (5,0,5)(0,1,0)(12)",
       y = "Daily Deaths") 


### South Region
south_test_plot <- as.data.frame(south_test_ts) %>% 
  mutate(num = seq(909, (909+226)))

south_tuned_sarima_plot <- forecast::autoplot(south_values) +
  geom_line(data = south_test_plot, aes(x = num, y = daily_deaths)) +
  scale_x_continuous(
    breaks = c(0, 300, 600 , 900),
    labels = c("Feb 2020", "Dec 2020", "Oct 2021", "July 2022")
  ) +
  labs(title = "South Region SARIMA (2,0,2)(1,1,0)(12)",
       y = "Daily Deaths")


### West Region
west_test_plot <- as.data.frame(west_test_ts) %>% 
  mutate(num = seq(909, (909+226)))

west_tuned_sarima_plot <- forecast::autoplot(west_values) +
  geom_line(data = west_test_plot, aes(x = num, y = daily_deaths)) +
  scale_x_continuous(
    breaks = c(0, 300, 600 , 900),
    labels = c("Feb 2020", "Dec 2020", "Oct 2021", "July 2022")
  ) +
  labs(title = "West Region SARIMA (4,0,5)(1,1,1)(12)",
       y = "Daily Deaths") 

save(east_initial_sarima_plot,
     east_initial_sarima_acc,
     east_tuned_sarima_plot,
     east_tuned_sarima_acc,
     midwest_initial_sarima_plot,
     midwest_initial_sarima_acc,
     midwest_tuned_sarima_plot,
     midwest_tuned_sarima_acc,
     south_initial_sarima_plot,
     south_initial_sarima_acc,
     south_tuned_sarima_plot,
     south_tuned_sarima_acc,
     west_initial_sarima_plot,
     west_initial_sarima_acc,
     west_tuned_sarima_plot,
     west_tuned_sarima_acc,
     file = "results/uni_sarima.rda"
     )
