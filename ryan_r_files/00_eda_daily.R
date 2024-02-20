# Looking at Daily 

# Load package(s) ---------------------------------------------------------
library(tidymodels)
library(tidyverse)
library(lubridate)
library(timeDate)
library(kableExtra)

nyt <- read_csv("data/nyt.csv")

## initial EDA ##########################################################

# count of observations for each state
nyt %>% 
  group_by(state) %>% 
  count() %>% 
  kbl() %>% 
  kable_minimal()

daily_missing <- miss_var_summary(nyt)

daily_missing %>% 
  kbl() %>% 
  kable_classic()

# adding state abb, turning cumulative deaths into daily deaths
# removing negative deaths
nyt2 <- nyt %>% 
  select(date, state, deaths) %>% 
  group_by(state) %>% 
  mutate(diff = (deaths) - lag(deaths, default = first(deaths))) %>% 
  mutate(diff = ifelse(diff < 0, 0, diff)) %>% 
  mutate(location = state.abb[match(state,state.name)])

# adding a column for region
nyt_region <- nyt2 %>% 
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
                               location == 'VT'| location == 'NJ' | location == 'NY' | location == 'PA') ~ "East")) %>% 
  group_by(region, date) %>% 
  mutate(daily_deaths = sum(diff, na.rm = TRUE))

# taking distinct dates / regions
nyt_new <- nyt_region %>% 
  distinct(date, region, daily_deaths) %>% 
  filter(!is.na(region)) %>% 
  mutate(daily_deaths = case_when((date == "2022-11-11" & region == "South") ~ 84,
                                  (date == "2022-11-11" & region == "West") ~ 84,
                                  (date == "2022-11-11" & region == "East") ~ 146,
                                  (date == "2022-11-11" & region == "Midwest") ~ 256,
                                  (date == "2021-02-12" & region == "Midwest") ~ 1221,
                                  (date == "2021-11-18" & region == "Midwest") ~ 581,
                                  (date == "2021-02-04" & region == "Midwest") ~ 518,
                                  (date == "2020-06-25" & region == "East") ~ 203,
                                  .default = daily_deaths)) %>% 
  filter(date >= "2020-02-12")

## EDA WITH DAILY DEATHS ##########################################

# distribution of total deaths
nyt_new %>% 
  ggplot(aes(daily_deaths)) +
  geom_histogram(bins = 50) +
  scale_fill_viridis_d(option = "C")

# distribution of daily deaths across regions
nyt_new %>% 
  ggplot(aes(daily_deaths, fill = region)) +
  geom_histogram(bins = 40) +
  scale_fill_viridis_d(option = "C") +
  facet_wrap(~region)

nyt_new %>% 
  ggplot(aes(log(daily_deaths), fill = region)) +
  geom_boxplot() +
  scale_fill_viridis_d(option = "C") +
  facet_wrap(~region)

# logging distribution of daily deaths across regions
nyt_new %>% 
  ggplot(aes((daily_deaths), fill = region)) +
  geom_histogram(bins = 40) +
  scale_fill_viridis_d(option = "C") +
  facet_wrap(~region)

nyt_new %>% 
  ggplot(aes(log(daily_deaths), fill = region)) +
  geom_boxplot() +
  scale_fill_viridis_d(option = "C") +
  facet_wrap(~region)

## TEMPORAL ANALYSIS ##########################################

# deaths over time by region
nyt_new %>% 
  ggplot(aes(date, daily_deaths, color = region)) +
  geom_point(size = 0.2) +
  geom_line(linewidth = 0.2) +
  scale_color_viridis_d(option = "C") +
  facet_wrap(~region)

# deaths over time in total
nyt_new %>% 
  ggplot(aes(date, daily_deaths)) +
  geom_point(size = 0.2)

write_csv(nyt_new, file = "data/new_daily_deaths.csv")

## SPLLITTING DATA UP ############################################

# East ###############################
east <- nyt_new %>% 
  filter(region == "East") %>% 
  distinct(date, .keep_all = TRUE) %>% 
  ungroup() %>% 
  select(-c(region))

east %>% 
  ggplot(aes(date, daily_deaths)) +
  geom_point(size = 0.2) +
  geom_line(linewidth = 0.2)

east %>% 
  ggplot(aes(log(daily_deaths))) +
  geom_histogram()

write_csv(east, file = "data/east_daily.csv")

# West ###############################
west <- nyt_new %>% 
  filter(region == "West") %>% 
  distinct(date, .keep_all = TRUE) %>% 
  ungroup() %>% 
  select(-c(region))

west %>% 
  ggplot(aes(date, daily_deaths)) +
  geom_point(size = 0.2) +
  geom_line(linewidth = 0.2)

write_csv(west, file = "data/west_daily.csv")

# Midwest ###############################

midwest <- nyt_new %>% 
  filter(region == "Midwest") %>% 
  distinct(date, .keep_all = TRUE) %>% 
  ungroup() %>% 
  select(-c(region))

midwest %>% 
  ggplot(aes(date, daily_deaths)) +
  geom_point(size = 0.2) +
  geom_line(linewidth = 0.2)

write_csv(midwest, file = "data/midwest_daily.csv")

# South ###############################

south <- nyt_new %>% 
  filter(region == "South") %>% 
  distinct(date, .keep_all = TRUE) %>% 
  select(date, daily_deaths) %>% 
  ungroup() %>% 
  select(-c(region))

south %>% 
  ggplot(aes(date, daily_deaths)) +
  geom_point(size = 0.2) +
  geom_line(linewidth = 0.2)

write_csv(south, file = "data/south_daily.csv")

nyt %>% 
  group_by(state) %>% 
  count() %>% 
  kbl() %>% 
  kable_minimal()

## LOOKING AT OLD CDC DATA VS NEW DAILY DATA ############################################

joined <- full_join(nyt, mc, by = c("date" = "date.x", "state" = "state"))
left <- left_join(mc, nyt2, by = c("date.x" = "date", "state" = "state"))

left <- left %>% 
  select(date.x, state, covid_19_deaths, deaths) %>% 
  group_by(date.x, state) %>% 
  mutate(diff = first(deaths) - lag(deaths))

# looking at cumulative totals
left2 <- left %>% 
  filter(state == "Alabama") %>% 
  mutate(totes_old = sum(covid_19_deaths, na.rm = TRUE))
