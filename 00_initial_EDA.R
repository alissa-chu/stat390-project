# 00 initial exploratory data analysis
library(tidymodels)
library(tidyverse)

library(kableExtra)
library(corrplot)

# handle common conflicts
tidymodels_prefer()

# seed
set.seed(3013)

vaccines <- read_csv("data/COVID-19_Vaccinations_in_the_United_States_Jurisdiction_20240111.csv")
deaths <- read_csv("data/Provisional_COVID-19_Death_Counts_by_Week_Ending_Date_and_State_20240113.csv")

deaths <- deaths %>% 
  mutate(Location = state.abb[match(State,state.name)])

write_csv(deaths, file = "data/deaths_with_abbs.csv")

covid <- read_csv("data/COVID-19_Vaccinations_in_the_United_States_Jurisdiction_20240111.csv")


skimr::skim(covid)

# looking at missing data
missing_table <- naniar::miss_var_summary(covid) %>% 
  # filter(pct_miss > 20) %>% 
  kbl() %>% 
  kable_classic()

missing_table

covid %>% 
  select(Second_Booster)
