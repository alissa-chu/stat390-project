# 00 initial exploratory data analysis

# Initial Setup

# Load package(s) ---------------------------------------------------------
library(tidymodels)
library(tidyverse)
library(kableExtra)
library(corrplot)
library(naniar)
library(lubridate)

og_vaccine <- read_csv("data/COVID-19_Vaccinations_in_the_United_States_Jurisdiction_20240111.csv") %>% 
  janitor:: clean_names()
og_deaths <- read_csv("data/Provisional_COVID-19_Death_Counts_by_Week_Ending_Date_and_State_20240113.csv") %>% 
  janitor:: clean_names()

deaths_2 <- read_csv("data/deaths_2.csv") %>% 
  janitor:: clean_names()

pls <- og_deaths %>% 
  mutate(date = as.Date(end_date, "%m/%d/%Y")) %>% 
  filter(state != "United States") %>% 
  select(covid_19_deaths, state, date) %>% 
  distinct(date, .keep_all = TRUE)

ugh <- deaths_2 %>% 
  mutate(date = as.Date(end_date, "%m/%d/%Y")) %>% 
  select(date, new_deaths) %>% 
  distinct(date, .keep_all = TRUE)

### STARTING WITH VACCINES ---------------------------------------------------------

# need to make date column date
og_vaccine <- og_vaccine %>% 
  mutate(date = as.Date(date, "%m/%d/%Y"))

# missingness
gg_miss_var(og_vaccine)
as_shadow(og_vaccine)
miss_vax_table <- miss_var_summary(og_vaccine) %>% 
  filter(pct_miss > 20)

miss_vax_table %>% 
  kbl() %>% 
  kable_classic()

# mutating
og_vaccine <- og_vaccine %>%
  group_by(date) %>% 
  mutate(total_distributed = sum(distributed))

vax_date <- og_vaccine %>% 
  distinct(date, .keep_all = TRUE) %>% 
  select(date, total_distributed)

ggplot(vax_date, aes(x = date, y = total_distributed)) +
  geom_point(size = 0.2)

# looking at just CA
ca_vax <- og_vaccine %>%
  filter(location == "CA") %>% 
  mutate(ca_distributed = sum(distributed)) %>%
  distinct(date, .keep_all = TRUE) %>% 
  select(date, ca_distributed)

ggplot(ca_vax, aes(x = date, y = ca_distributed)) +
  geom_point(size = 0.2)

# looking at just NY
ny_vax <- og_vaccine %>%
  filter(location == "NY") %>% 
  mutate(ny_distributed = sum(distributed)) %>%
  distinct(date, .keep_all = TRUE) %>% 
  select(date, ny_distributed)

ggplot(ny_vax, aes(x = date, y = ny_distributed)) +
  geom_point(size = 0.2)

# looking at just va
va_vax <- og_vaccine %>%
  filter(location == "VA") %>% 
  mutate(va_distributed = sum(distributed)) %>%
  distinct(date, .keep_all = TRUE) %>% 
  select(date, va_distributed)

ggplot(va_vax, aes(x = date, y = va_distributed)) +
  geom_point(size = 0.2)

# combining all 3
three_vaccines <- og_vaccine %>% 
  filter(location == "VA" | location == "CA" | location == "NY") %>% 
  group_by(location) %>% 
  select(distributed, location, date)

ggplot(three_vaccines, aes(x = date, y = distributed, color = location)) +
  geom_point(size = 0.5) + 
  labs(title = "California, New York, and Virginia Total # of Distributed Doses", 
       y = "# Vaccines Distributed",
       x = "Date")


# Starting June 16, 2022 -> data becomes weekly instead of daily

## LOOKING AT DEATHS ---------------------------------------------------------

gg_miss_var(og_deaths)
as_shadow(og_deaths)
miss_death_table <- miss_var_summary(og_deaths) %>% 
  filter(pct_miss > 20)

miss_death_table

# week ending date is the same thing as end date, so not important!
# mmwr week is easily found
# month is easily found
# footnote is irrelevant

# adding Location to match the other data set
og_deaths <- og_deaths %>% 
  mutate(location = state.abb[match(state,state.name)]) %>% 
  filter(state != "United States") %>% 
  mutate(date = as.Date(end_date, "%m/%d/%Y")) %>% 
  select(date, covid_19_deaths)

# looking at total covid 19 deaths
deaths <- og_deaths %>%
  mutate(covid_19_deaths = ifelse(is.na(covid_19_deaths), 0, covid_19_deaths)) %>% 
  group_by(date) %>%
  mutate(total_covid_deaths = sum(covid_19_deaths)) %>% 
  select(date, total_covid_deaths) %>% 
  distinct(date, .keep_all = TRUE)

ggplot(deaths, aes(x = date, y = total_covid_deaths)) +
  geom_point(size = 0.2)


## LOOKING AT MERGED DATASET ---------------------------------------------------------
covid_deaths <- read_csv("data/copy_covid_deaths2.csv")

covid_deaths <- covid_deaths %>% 
  janitor::clean_names() %>% 
  select(-c("x1", "location", "date"))

c1 <- cor(covid_deaths[90:119])

c <- cor(covid_deaths)

corrplot(c1, method = 'color')

