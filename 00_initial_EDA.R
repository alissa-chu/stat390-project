# 00 initial exploratory data analysis
library(tidymodels)
library(kableExtra)
library(corrplot)

# handle common conflicts
tidymodels_prefer()

# seed
set.seed(3013)

covid <- COVID_19_Vaccinations_in_the_United_States_Jurisdiction_20240111

skimr::skim(covid)

# looking at missing data
missing_table <- naniar::miss_var_summary(covid) %>% 
  filter(pct_miss > 20) %>% 
  kbl() %>% 
  kable_classic()

missing_table
