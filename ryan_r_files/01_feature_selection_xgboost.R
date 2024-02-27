
## XG BOOST ###############################################################

# Step 1: Install and load the required packages
library(xgboost)
library(caret)
library(tidyverse)

clean_data <- read_csv("data/merged_cleaned_processed.csv")

cv_data <- clean_data %>% 
  select(-c(location, ...1, date.y)) %>% 
  rename(deaths = covid_19_deaths) %>% 
  mutate(second_booster = as.numeric(second_booster))

# Step 2: Prepare your time series data
# Example: Suppose you have a time series data frame named 'ts_data' with features and a target variable.

# Step 3: Split the data into training and testing sets
set.seed(123) # for reproducibility
trainIndex <- createDataPartition(cv_data$deaths, p = .8, 
                                  list = FALSE, 
                                  times = 1)
data_train <- cv_data[trainIndex, ]
data_test  <- cv_data[-trainIndex, ]

data_train2 <- data_train %>% 
  select(-c(deaths, date.x))

data_test2 <- data_test %>% 
  select(-c(deaths, date.x))


# Step 4: Train an XGBoost model on the training set
xgb_model <- xgboost(data = as.matrix(data_train2), 
                     label = data_train$deaths, 
                     nrounds = 100, # specify the number of boosting rounds
                     objective = "reg:squarederror") # for regression tasks

# Step 5: Evaluate the model's performance
# Example: You can use mean squared error (MSE) for evaluation.
predictions <- predict(xgb_model, as.matrix(data_test2))
mse <- mean((predictions - data_test$deaths)^2)
rmse <- sqrt(mse)
print(paste("Mean Squared Error:", mse))
print(paste("Root Mean Squared Error:", rmse))
print(paste("R-Squared", rsq))
summary(xgb_model)

rss <- sum((predictions - data_test$deaths) ^ 2)  ## residual sum of squares
tss <- sum((data_test$deaths - mean(data_test$deaths)) ^ 2)  ## total sum of squares
rsq <- 1 - rss/tss

# Step 6: Extract feature importance scores
importance_matrix <- xgb.importance(feature_names = colnames(data_train2), 
                                    model = xgb_model)
print(importance_matrix) %>% 
  kableExtra::kbl() %>% 
  kableExtra::kable_classic()

# Plot feature importance
xgb.plot.importance(importance_matrix = importance_matrix)

## PACF & ACF ###########################################################################
# Load necessary libraries
library(forecast)

# Example time series data
# Let's create a simple time series with 100 observations
set.seed(123)

cv_data2 <- cv_data %>% 
  select(date.x, deaths)

# Plot the time series data
plot(cv_data2, main = "COVID-19 Deaths Over Times")

# Auto-correlation analysis
# Plot the auto-correlation function
acf(cv_data2, type = "correlation", lag.max = 20, plot = TRUE)

# Partial auto-correlation analysis
# Plot the partial auto-correlation function
pacf(cv_data2, lag.max = 20, plot = TRUE)

