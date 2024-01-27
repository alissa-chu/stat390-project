# Feature Engineering 

# Load package(s) ---------------------------------------------------------
library(tidymodels)
library(tidyverse)
library(kableExtra)
library(corrplot)
library(ggcorrplot)
library(correlation)
library(naniar)
library(lubridate)
library(gridExtra)

merged_clean <- read_csv("data/merged_clean.csv")

merged_clean <- merged_clean %>% 
  select(-c(date.y, month.y,)) %>% 
  mutate(day_of_week = wday(date.x))

merged_clean %>% 
  ggplot(aes(x = covid_19_deaths)) + 
  geom_histogram(bins = 50)


merged_clean %>% 
  ggplot(aes(x = log(covid_19_deaths))) + 
  geom_histogram(bins = 50)

merged_clean %>% 
  ggplot(aes(x = season)) +
  geom_bar()

merged_clean %>% 
  ggplot(aes(x = region)) +
  geom_bar()

date <- merged_clean %>% 
  select(date.x)

deaths <- merged_clean %>% 
              select(covid_19_deaths)

date2 <- merged_clean$date.x
deaths2 <- merged_clean$covid_19_deaths

class(date2)
class(deaths2)

cor(date2, deaths2)
plot(date, deaths)

acf(date2)
acf(deaths2)
?acf
