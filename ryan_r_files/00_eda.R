# Initial Setup

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

og_vaccine <- read_csv("data/og_vaccine.csv") %>% 
  janitor:: clean_names()
og_deaths <- read_csv("data/og_deaths.csv") %>% 
  janitor:: clean_names()

deaths_2 <- read_csv("data/deaths_2.csv") %>% 
  janitor:: clean_names()
# I think we have to make NY and NYC two different things

pls <- og_deaths %>% 
  mutate(date = as.Date(end_date, "%m/%d/%Y")) %>% 
  filter(state != "United States") %>% 
  select(covid_19_deaths, state, date) %>% 
  distinct(date, .keep_all = TRUE)
filter <- og_deaths %>% 
  filter(group != "By Month",
         group != "By Year")

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
three_vaccines <- new_vax %>% 
  filter(location == "VA" | location == "CA" | location == "NY") %>% 
  group_by(location) %>% 
  select(distributed, location, date)

ggplot(three_vaccines, aes(x = date, y = distributed, color = location)) +
  geom_point(size = 0.5) + 
  labs(title = "California, New York, and Virginia Total # of Distributed Doses", 
       y = "# Vaccines Distributed",
       x = "Date")

oregon <- og_vaccine %>% 
  filter(location == "OR") %>% 
  select(date, location, mmwr, distributed)

# creating year column
# creating month column 

og_vaccine <- og_vaccine %>% 
  mutate(year = year(date),
         month = month(date))

# adding regions
new_vax <- og_vaccine  %>% 
  filter(location != "US")

# keeping only wednesday to keep it consistent
new_vax <- new_vax %>% 
  mutate(day_of_week = wday(date)) %>% 
  filter(day_of_week == 4)


new_vax %>% 
  filter(is.na(region)) %>% 
  select(location) %>% 
  distinct(location) %>% 
  kbl() %>% 
  kable_minimal()

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
  filter(state != "United States") %>% 
  mutate(location = state.abb[match(state,state.name)]) %>% 
  mutate(location = case_when((state == "Puerto Rico") ~ 'PR',
                              (state == "District of Columbia") ~ 'DC',
                              (state == "New York City") ~ 'NY',
                              TRUE ~ location)) %>%
  mutate(date = as.Date(end_date, "%m/%d/%Y"),
         month = month(date),
         year = year(date)) %>% 
  filter(group == "By Week")

new_deaths <- og_deaths %>% 
  group_by(location, date) %>% 
  mutate(covid_19_deaths = sum(covid_19_deaths)) %>% 
  distinct(date, location, covid_19_deaths, .keep_all = TRUE)

new_deaths <- new_deaths %>% 
  select(date, state, location, year, month, mmwr_week, covid_19_deaths)
  

ny_deaths <- og_deaths %>% 
  filter(state == "New York") %>% 
  filter(group == "By Week") %>% 
  select(date, state, covid_19_deaths)

nyc_deaths <- og_deaths %>% 
  filter(state == "New York City") %>% 
  filter(group == "By Week") %>% 
  select(date, state, covid_19_deaths)

ny <- og_deaths %>% 
  filter(state == "New York City" | state == "New York") %>% 
  filter(group == "By Week") %>% 
  select(date, state, covid_19_deaths)

ny2 <- ny %>%
  mutate(state = case_when((state == 'New York City') ~ 'New York',
                           (state == 'New York') ~ 'New York')) %>% 
  group_by(date, state) %>% 
  mutate(covid_19_deaths = sum(covid_19_deaths)) %>% 
  distinct(date, state, covid_19_deaths)

p1 <- ny_deaths %>% 
  ggplot(aes(x = date, y = covid_19_deaths)) +
  geom_point()

p2 <- nyc_deaths %>% 
  ggplot(aes(x = date, y = covid_19_deaths)) +
  geom_point()

grid.arrange(p1, p2, ncol = 2)

## MERGING DATASETS ---------------------------------------------------------

vax <- new_vax %>% 
  select(date, mmwr_week, location, distributed)

View(new_vax)
View(new_deaths)

merged <- left_join(new_deaths, new_vax, join_by(mmwr_week == mmwr_week, location == location, year == year))

see <- merged %>% 
  select(date.x, date.y, covid_19_deaths, location, mmwr_week, year, distributed)

merged_clean <- merged %>% 
  mutate(region = case_when((location == "AK" | location == "CA" | location == 'HI' | location == 'OR' | location =='WA'| 
                               location =='AZ' | location == 'CO'| location == 'ID'| location == 'NM' |location == 'MT' | 
                               location == 'UT'| location == 'NV' | location == 'WY') ~ 'West',
                            (location == 'IN' | location == 'IL' | location == 'MI' | location == 'OH' | location =='WI'| 
                               location =='IA'| location =='NE' | location == 'KS'| location =='ND' | location=='MN' | 
                               location=='SD' | location=='MO') ~ 'Midwest',
                            (location == 'DE' | location == 'DC' | location == 'FL' | location== 'GA' | location == 'MD' | 
                               location== 'NC' | location== 'SC' | location== 'VA' | location== 'WV' | location== 'AL' | 
                               location == 'KY' | location == 'MS' | location == 'TN' | location == 'AR'| location == 'LA'| 
                               location == 'OK' | location == 'TX') ~ 'South',
                            (location == 'CT' | location== 'ME' | location == 'MA' | location == 'NH' | location == 'RI' | 
                               location == 'VT'| location == 'NJ' | location == 'NY' | location == 'PA') ~ "East",
                            (location == 'PR') ~ "Puerto Rico")) %>% 
  mutate(month = month.x) %>% 
  mutate(season = case_when((month == 12 | month == 1 | month == 2) ~ 'Winter',
                            (month == 3 | month == 4 | month == 5) ~ 'Spring',
                            (month == 6 | month == 7 | month == 8) ~ 'Summer',
                            (month == 9 | month == 10 | month == 11) ~ 'Fall'))

pee <- merged %>% 
  filter(!is.na(covid_19_deaths))

lala <- merged_clean %>% 
  group_by(date.x, region) %>% 
  mutate(region_deaths = sum(covid_19_deaths, na.rm = TRUE)) %>% 
  select(date.x, covid_19_deaths, region_deaths, region) %>% 
  distinct(date.x, region, .keep_all = TRUE)

lala %>% 
  ggplot(aes(x = date.x, y = region_deaths, color = region)) +
  geom_point(size = 0.2) +
  geom_line()

write_csv(merged_clean, file = "data/merged_clean.csv")

miss_merged <- miss_var_summary(merged_clean) %>% 
  filter(pct_miss > 20)

miss_merged %>% 
  kbl() %>%
  kable_classic()


# looking at total covid 19 deaths
deaths <- og_deaths %>%
  mutate(covid_19_deaths = ifelse(is.na(covid_19_deaths), 0, covid_19_deaths)) %>% 
  group_by(date) %>%
  mutate(total_covid_deaths = sum(covid_19_deaths)) %>% 
  select(date, total_covid_deaths) %>% 
  distinct(date, .keep_all = TRUE)

ggplot(deaths, aes(x = date, y = total_covid_deaths)) +
  geom_point(size = 0.2)
  

# creating region in death dataset
new_deaths <- og_deaths %>%
  mutate(region = case_when((location == "AK" | location == "CA" | location == 'HI' | location == 'OR' | location =='WA'| 
                               location =='AZ' | location == 'CO'| location == 'ID'| location == 'NM' |location == 'MT' | 
                               location == 'UT'| location == 'NV' | location == 'WY') ~ 'West',
                            (location == 'IN' | location == 'IL' | location == 'MI' | location == 'OH' | location =='WI'| 
                               location =='IA'| location =='NE' | location == 'KS'| location =='ND' | location=='MN' | 
                               location=='SD' | location=='MO') ~ 'Midwest',
                            (location == 'DE' | location == 'DC' | location == 'FL' | location== 'GA' | location == 'MD' | 
                               location== 'NC' | location== 'SC' | location== 'VA' | location== 'WV' | location== 'AL' | 
                               location == 'KY' | location == 'MS' | location == 'TN' | location == 'AR'| location == 'LA'| 
                               location == 'OK' | location == 'TX') ~ 'South',
                            (location == 'CT' | location== 'ME' | location == 'MA' | location == 'NH' | location == 'RI' | 
                               location == 'VT'| location == 'NJ' | location == 'NY' | location == 'PA') ~ "Northeast",
                            (location == 'PR') ~ "Puerto Rico")) %>% 
  filter(location != "US",
         group != "By Year",
         group != "By Month",
         group != "By Total") %>% 
  select(-c(footnote, data_as_of, state, start_date, end_date)) %>% 
  mutate(month = month(date),
         year = year(date))

merged <- left_join(new_deaths, new_vax, by = c("location" = "location", "year" = "year", "mmwr_week" = "mmwr_week"))

new <- merged %>% 
  select(date.x, date.y) %>% 
  distinct(date.x, date.y)

rah <- merged %>% 
  select(date.x, covid_19_deaths, region.x, region.y)

## LOOKING AT MERGED ---------------------------------------------------------

cd2 <- read_csv("data/covid_deaths2.csv") %>% 
  janitor::clean_names()

see <- cd2 %>% 
  select(date, covid19_deaths, location)

cd2 <- cd2 %>% 
  mutate(region = case_when((region_y_east == 1) ~ "East",
                            (region_y_west == 1) ~ "West",
                            (region_y_south == 1) ~ "South",
                            (region_y_midwest == 1) ~ "Midwest",
                            (region_y_pr == 1) ~ "Puerto Rico")) %>% 
  distinct(covid19_deaths, location, .keep_all = TRUE)


cd2 %>% 
  filter(location == "CA" |
           location == "TX" |
           location == "NY") %>% 
  ggplot(aes(x = date, y = covid19_deaths, color = location)) +
  geom_point() +
  geom_smooth()


plot1 <- cd2 %>% 
  group_by(date, region) %>% 
  mutate(totes = sum(covid19_deaths)) %>% 
  ggplot(aes(x = date, y = totes, color = region)) +
  geom_point(size = 0.2) +
  geom_line() + 
  labs(title = "Total Deaths Per Region ")

plot2 <- cd2 %>% 
  group_by(date, region) %>% 
  mutate(avg = mean(covid19_deaths)) %>% 
  ggplot(aes(x = date, y = avg, color = region)) +
  geom_point(size = 0.2) +
  geom_line() +
  labs(title = "Average Deaths Per Region")

grid.arrange(plot1, plot2, ncol=2)

south <- cd2 %>% 
  filter(region == "South") %>% 
  select(covid19_deaths, date, location) %>% 
  distinct(covid19_deaths, location, .keep_all = TRUE)

totes <- cd2 %>% 
  group_by(date, region) %>% 
  mutate(totes = sum(covid19_deaths)) %>% 
  select(date, covid19_deaths, totes, location) %>% 
  distinct(region, date, totes, .keep_all = TRUE)

totes %>% 
  ggplot(aes(x = date, y = covid19_deaths, color = region)) +
  geom_point(size = 0.2) +
  geom_smooth()

cor_cd2 <- cd2 %>% 
  select(-c(date, location, region)) %>% 
  correlation()

cor_cd2 <- cor_cd2 %>% 
  filter(r <= -0.6 |
         r >= 0.6)

ggcorrplot(corr = cor_cd2,
           lab = F)

c <- cor(cor_cd2)
corrplot(c, method = "color")

devtools::install_github("laresbernardo/lares")
library(lares)
corr_cross(cd2, # dataset
           max_pvalue = 0.05,
           min_pvalue = 0.90,# show only sig. correlations at selected level
           top = 30) # display top 10 correlations, any couples of variables  )
corr_var(cd2, # dataset
         covid19_deaths, # name of variable to focus on
         top = 20) # display top 10 correlations )


cov_death <- read_csv("data/COVID-19-Cases-USA-By-State.csv")
cov_death <- read_csv("data/time_series_covid19_deaths_US.csv")

alissa <- read_csv("data/alissa.csv") %>% 
  select(submission_date, state, tot_death)

cov_death2 <- cov_death %>% 
  select(-c(UID, iso2, iso3, code3, FIPS, Admin2, Country_Region, Lat, Long_)) %>% 
  group_by(Province_State) 

states <- read_csv("data/States.csv")

state <- states %>% 
  select(date, state, deaths) %>% 
  mutate(location = state.abb[match(state,state.name)]) %>% 
  mutate(region = case_when((location == "AK" | location == "CA" | location == 'HI' | location == 'OR' | location =='WA'| 
                               location =='AZ' | location == 'CO'| location == 'ID'| location == 'NM' |location == 'MT' | 
                               location == 'UT'| location == 'NV' | location == 'WY') ~ 'West',
                            (location == 'IN' | location == 'IL' | location == 'MI' | location == 'OH' | location =='WI'| 
                               location =='IA'| location =='NE' | location == 'KS'| location =='ND' | location=='MN' | 
                               location=='SD' | location=='MO') ~ 'Midwest',
                            (location == 'DE' | location == 'DC' | location == 'FL' | location== 'GA' | location == 'MD' | 
                               location== 'NC' | location== 'SC' | location== 'VA' | location== 'WV' | location== 'AL' | 
                               location == 'KY' | location == 'MS' | location == 'TN' | location == 'AR'| location == 'LA'| 
                               location == 'OK' | location == 'TX') ~ 'South',
                            (location == 'CT' | location== 'ME' | location == 'MA' | location == 'NH' | location == 'RI' | 
                               location == 'VT'| location == 'NJ' | location == 'NY' | location == 'PA') ~ "Northeast",
                            (location == 'PR') ~ "Puerto Rico")) 
state2 <- state %>% 
  group_by(region, date) %>% 
  mutate(total_deaths = sum(deaths))

state3 <- state2 %>% 
  distinct(region, total_deaths,date)

state3 %>% 
  group_by(region) %>% 
  count()

states %>% 
  distinct(state) %>% 
  kbl()

state3 %>% 
  ggplot(aes(date, total_deaths, color = region)) +
  geom_point(size = 0.2) +
  geom_line()
