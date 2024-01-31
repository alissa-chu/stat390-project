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
library(chron)
library(timeDate)
library(MMWRweek)

merged_clean <- read_csv("data/merged_cleaned_processed.csv")
mc <- read_csv("data/merged_clean.csv")

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


mc2 <- mc %>% 
  group_by(region, date.x) %>% 
  mutate(region_deaths = sum(covid_19_deaths, na.rm = TRUE)) %>% 
  select(date.x, region_deaths, region) %>% 
  distinct(date.x, region_deaths, region)

totes_deaths <- ggplot(mc2) +
  geom_line(aes(x = date.x, y = region_deaths, color = region)) +
  geom_point(aes(x = date.x, y = region_deaths, color = region), size = 0.2) +
  scale_x_date(date_breaks = '4 month', date_labels = '%b %y') +
  theme(axis.text.x = element_text(angle = 25, vjust = 0.75),
        plot.caption = element_text(vjust = 7)) +
  labs(title = "Regional COVID-19 Deaths",
       y = "Total Deaths by Region",
       x = "Date",
       color = "Region")

totes_deaths

totes_death_by_region <- ggplot(mc2) +
  geom_rect(alpha = 0.009,
            aes(xmin = as.Date("2021-07-06"), xmax = as.Date("2021-12-01"), 
                ymin = 12500, ymax = 0), fill = "pink") +
  geom_rect(alpha = 0.002,
            aes(xmin = as.Date("2021-12-02"), xmax = as.Date("2023-02-01"), 
                ymin = 12500, ymax = 0), fill = "turquoise") +
  geom_line(aes(x = date.x, y = region_deaths, color = region)) +
  geom_point(aes(x = date.x, y = region_deaths, color = region), size = 0.2) +
  scale_x_date(date_breaks = '4 month', date_labels = '%b %y') +
  theme(axis.text.x = element_text(angle = 25, vjust = 0.75),
        plot.caption = element_text(vjust = 7)) +
  labs(title = "Regional COVID-19 Deaths",
       y = "Total Deaths by Region",
       x = "Date",
       color = "Region") +
  annotate(geom = "text", x = as.Date("2021-01-05"),
           y = 11300, size = 2, lineheight = 0.8,
           label = "Intro of COVID-19 vaccines \n for people 
           65+ and other \n vulnerable populations", fontface = "bold") +
  annotate(geom = "text", x = as.Date("2021-09-15"),
           y = 13000, size = 2, color = "magenta",
           label = "Delta Variant", fontface = "italic") +
  annotate(geom = "text", x = as.Date("2022-06-15"),
           y = 13000, size = 2, color = "turquoise",
           label = "Omicron Variant", fontface = "italic") +
  annotate(geom = "text", x = as.Date("2021-09-20"),
           y = 10700, size = 2, lineheight = 0.8,
           label = "First Booster \n made available", fontface = "bold") +
  annotate(geom = "text", x = as.Date("2022-02-20"),
           y = 9500, size = 2, lineheight = 0.8,
           label = "Second Booster \n made available", fontface = "bold")

totes_death_by_region

ggsave("ryan_r_files/graphics/totes_death_by_region.png")

mc3 <- mc %>% 
  group_by(date.x) %>% 
  mutate(total_deaths = sum(covid_19_deaths, na.rm = TRUE))

total_deaths_plot <- ggplot(mc3) +
  geom_point(aes(x = date.x, y = total_deaths), size = 0.5) +
  geom_line(aes(x = date.x, y = total_deaths)) +
  scale_x_date(date_breaks = '4 month', date_labels = '%b %y') +
  theme(axis.text.x = element_text(angle = 25, vjust = 0.75),
        plot.caption = element_text(vjust = 7)) + 
  labs(x = "Date",
       y = "Total Deaths",
       title = "Total Deaths by COVID-19 Over Time")  +
  annotate(geom = "text", x = as.Date("2021-09-20"),
           y = 17000, size = 2, lineheight = 0.8,
           label = "First Booster \n made available", fontface = "bold") +
  annotate(geom = "text", x = as.Date("2022-02-20"),
           y = 22500, size = 2, lineheight = 0.8,
           label = "Second Booster \n made available", fontface = "bold") +
  annotate(geom = "text", x = as.Date("2021-01-05"),
           y = 27500, size = 2, lineheight = 0.8,
           label = "Intro of COVID-19 vaccines \n for people 
           65+ and other \n vulnerable populations", fontface = "bold")

total_deaths_plot

mc4 <- mc %>% 
  group_by(date.x, region) %>% 
  mutate(total_administered = sum(administered, na.rm = TRUE)) %>% 
  select(date.x, total_administered, administered, region) %>% 
  distinct(date.x, total_administered, .keep_all = TRUE) %>% 
  group_by(region) %>% 
  filter(date.x != "2022-01-01")

admin_region <- ggplot(mc4) +
  geom_point(aes(x = date.x, y = total_administered, color = region), size = 0.5) +
  geom_line(aes(x = date.x, y = total_administered, color = region)) +
  scale_x_date(date_breaks = '4 month', date_labels = '%b %y', limits = as.Date(c('2020-09-01','2023-04-01'))) +
  theme(axis.text.x = element_text(angle = 25, vjust = 0.75),
        plot.caption = element_text(vjust = 7)) + 
  labs(x = "Date",
       y = "Total Administered",
       title = "Total Administered COVID-19 Vaccines Over Time By Region",
       color = "Region")

admin_region

mc4_2 <- mc %>% 
  group_by(date.x) %>% 
  mutate(total_administered = sum(administered, na.rm = TRUE)) %>% 
  select(date.x, total_administered, administered, region) %>% 
  distinct(date.x, total_administered, .keep_all = TRUE) %>%
  filter(date.x != "2022-01-01")

total_admin <- ggplot(mc4_2) +
  geom_point(aes(x = date.x, y = total_administered), size = 0.5) +
  geom_line(aes(x = date.x, y = total_administered)) +
  scale_x_date(date_breaks = '4 month', date_labels = '%b %y', limits = as.Date(c('2020-09-01','2023-04-01'))) +
  theme(axis.text.x = element_text(angle = 25, vjust = 0.75),
        plot.caption = element_text(vjust = 7)) + 
  labs(x = "Date",
       y = "Total Administered",
       title = "Total Administered COVID-19 Vaccines Over Time")

total_admin

mc5 <- mc %>% 
  group_by(date.x, region) %>% 
  mutate(total_add_doses = sum(additional_doses, na.rm = TRUE)) %>% 
  select(date.x, total_add_doses, administered, region) %>% 
  distinct(date.x, total_add_doses, .keep_all = TRUE) %>% 
  group_by(region) %>% 
  filter(date.x != "2022-01-01")

add_doses_plot_reg <- ggplot(mc5) +
  geom_point(aes(x = date.x, y = total_add_doses, color = region), size = 0.5) +
  geom_line(aes(x = date.x, y = total_add_doses, color = region)) +
  scale_x_date(date_breaks = '4 month', date_labels = '%b %y', limits = as.Date(c('2020-09-01','2023-04-01'))) +
  theme(axis.text.x = element_text(angle = 25, vjust = 0.75),
        plot.caption = element_text(vjust = 7)) + 
  labs(x = "Date",
       y = "Total Additional Doses",
       title = "Total Additional Doses COVID-19 Vaccines Over Time By Region")
add_doses_plot_reg 

mc6 <- mc %>% 
  group_by(date.x, region) %>% 
  mutate(total_series = sum(series_complete_yes, na.rm = TRUE)) %>% 
  select(date.x, total_series, series_complete_yes, region) %>% 
  distinct(date.x, total_series, .keep_all = TRUE) %>% 
  group_by(region) %>% 
  filter(date.x != "2022-01-01")

series_complete_region <- ggplot(mc6) +
  geom_point(aes(x = date.x, y = total_series, color = region), size = 0.5) +
  geom_line(aes(x = date.x, y = total_series, color = region)) +
  scale_x_date(date_breaks = '4 month', date_labels = '%b %y', limits = as.Date(c('2020-09-01','2023-04-01'))) +
  theme(axis.text.x = element_text(angle = 25, vjust = 0.75),
        plot.caption = element_text(vjust = 7)) + 
  labs(x = "Date",
       y = "Total Number of People \n who have Completed Vax Series",
       title = "Total Complete Series of COVID-19 Vaccines Over Time By Region",
       color = "Region")
series_complete_region

mc7 <- mc %>% 
  group_by(date.x, region) %>% 
  mutate(admin_100 = sum(admin_per_100k, na.rm = TRUE)) %>% 
  select(date.x, admin_100, admin_per_100k, region) %>% 
  distinct(date.x, admin_100, .keep_all = TRUE) %>% 
  group_by(region) %>% 
  filter(date.x != "2022-01-01")

admin_per_100 <- ggplot(mc7) +
  geom_point(aes(x = date.x, y = admin_100, color = region), size = 0.5) +
  geom_line(aes(x = date.x, y = admin_100, color = region)) +
  scale_x_date(date_breaks = '4 month', date_labels = '%b %y', limits = as.Date(c('2020-09-01','2023-04-01'))) +
  theme(axis.text.x = element_text(angle = 25, vjust = 0.75),
        plot.caption = element_text(vjust = 7)) + 
  labs(x = "Date",
       y = "Total Administered Vaccines \n Per 100k People",
       title = "Total Vaccines Administered Per 100k Over Time By Region",
       color = "Region")
admin_per_100

mc7_2 <- mc %>% 
  group_by(date.x) %>% 
  mutate(admin_100 = sum(admin_per_100k, na.rm = TRUE)) %>% 
  select(date.x, admin_100, admin_per_100k, region) %>% 
  distinct(date.x, admin_100, .keep_all = TRUE) %>%
  filter(date.x != "2022-01-01")

admin_per_100_total <- ggplot(mc7_2) +
  geom_point(aes(x = date.x, y = admin_100), size = 0.5) +
  geom_line(aes(x = date.x, y = admin_100)) +
  scale_x_date(date_breaks = '4 month', date_labels = '%b %y', limits = as.Date(c('2020-09-01','2023-04-01'))) +
  theme(axis.text.x = element_text(angle = 25, vjust = 0.75),
        plot.caption = element_text(vjust = 7)) + 
  labs(x = "Date",
       y = "Total Administered Vaccines \n Per 100k People",
       title = "Total Vaccines Administered Per 100k Over Time")
admin_per_100_total


mc8 <- mc %>% 
  group_by(date.x, region) %>% 
  mutate(biv = sum(administered_bivalent, na.rm = TRUE)) %>% 
  select(date.x, biv, administered_bivalent, region) %>% 
  distinct(date.x, biv, .keep_all = TRUE) %>% 
  group_by(region) %>% 
  filter(date.x != "2022-01-01")

total_bivalent <- ggplot(mc8) +
  geom_point(aes(x = date.x, y = biv, color = region), size = 0.5) +
  geom_line(aes(x = date.x, y = biv, color = region)) +
  scale_x_date(date_breaks = '4 month', date_labels = '%b %y', limits = as.Date(c('2020-12-01','2023-04-01'))) +
  theme(axis.text.x = element_text(angle = 25, vjust = 0.75),
        plot.caption = element_text(vjust = 7)) + 
  labs(x = "Date",
       y = "Total Bivalent Vaccines",
       title = "Total Bivalent Vaccines Administered Over Time By Region",
       color = "Region")
total_bivalent


mc2_2 <- mc %>% 
  group_by(region, date.x) %>% 
  mutate(region_deaths = sum(covid_19_deaths, na.rm = TRUE),
         total_admin = sum(administered)) %>% 
  select(date.x, region_deaths, region, total_admin) %>% 
  distinct(date.x, region_deaths, region, .keep_all = TRUE)

mc2_2 %>% 
  ggplot(aes(x = total_admin, y = region_deaths, color = region)) +
  geom_point() +
  geom_line() +
  geom_smooth()

univariate <- mc %>% 
  group_by(date.x) %>% 
  mutate(total_deaths = sum(covid_19_deaths)) %>% 
  select(date.x, total_deaths, region) %>% 
  distinct(date.x, region, .keep_all = TRUE) %>% 
  group_by(region) %>% 
  count()

mc %>% 
  distinct(date.x) %>% 
  count()

## Looking at Holidays #################################################################
holidays <- c(as.Date(Easter(2020)), as.Date(Easter(2021)), as.Date(Easter(2022)), as.Date(Easter(2023)), as.Date(Easter(2024)),
              as.Date(ChristmasDay(2020)), as.Date(ChristmasDay(2021)), as.Date(ChristmasDay(2022)), as.Date(ChristmasDay(2023)), as.Date(ChristmasDay(2024)),
              as.Date(ChristmasEve(2020)), as.Date(ChristmasEve(2021)), as.Date(ChristmasEve(2022)), as.Date(ChristmasEve(2023)), as.Date(ChristmasEve(2024)),
              as.Date(NewYearsDay(2020)), as.Date(NewYearsDay(2021)), as.Date(NewYearsDay(2022)), as.Date(NewYearsDay(2023)), as.Date(NewYearsDay(2024)),
              as.Date(USMLKingsBirthday(2020)), as.Date(USMLKingsBirthday(2021)), as.Date(USMLKingsBirthday(2022)), as.Date(USMLKingsBirthday(2023)), as.Date(USMLKingsBirthday(2024)),
              as.Date(USMemorialDay(2020)), as.Date(USMemorialDay(2021)), as.Date(USMemorialDay(2022)), as.Date(USMemorialDay(2023)), as.Date(USMemorialDay(2024)),
              as.Date(USIndependenceDay(2020)), as.Date(USIndependenceDay(2021)), as.Date(USIndependenceDay(2022)), as.Date(USIndependenceDay(2023)), as.Date(USIndependenceDay(2024)),
              as.Date(USColumbusDay(2020)), as.Date(USColumbusDay(2021)), as.Date(USColumbusDay(2022)), as.Date(USColumbusDay(2023)), as.Date(USColumbusDay(2024)),
              as.Date(USVeteransDay(2020)), as.Date(USVeteransDay(2021)), as.Date(USVeteransDay(2022)), as.Date(USVeteransDay(2023)), as.Date(USVeteransDay(2024)),
              as.Date(USThanksgivingDay(2020)), as.Date(USThanksgivingDay(2021)), as.Date(USThanksgivingDay(2022)), as.Date(USThanksgivingDay(2023)), as.Date(USThanksgivingDay(2024)),
              as.Date(USWashingtonsBirthday(2020)), as.Date(USWashingtonsBirthday(2021)), as.Date(USWashingtonsBirthday(2022)), as.Date(USWashingtonsBirthday(2023)), as.Date(USWashingtonsBirthday(2024)),
              as.Date(USJuneteenthNationalIndependenceDay(2021)), as.Date(USJuneteenthNationalIndependenceDay(2022)), 
              as.Date(USJuneteenthNationalIndependenceDay(2023)), as.Date(USJuneteenthNationalIndependenceDay(2024)))

mmwr_holidays <- MMWRweek(holidays)

mc_holidays2 <- left_join(mc, mmwr_holidays, join_by(year == MMWRyear, mmwr_week == MMWRweek))

see <- mc_holidays2 %>% 
  select(date.x, mmwr_week, year, MMWRweek.y)

mc_holidays <- mc_holidays2 %>% 
  mutate(MMWRday = ifelse(is.na(MMWRday), 0, 1)) %>% 
  rename(holiday = MMWRday)

ggplot(mc_holidays, aes(x = holiday)) +
  geom_bar(fill = c("#43A0E8", "#F57D6D")) +
  scale_x_continuous(breaks = c(0, 1), labels = c("Normal Week", "Holiday Week")) +
  labs(x = "Type of Week",
       y = "Count",
       title = "Distribution of Normal Weeks vs. Holiday Weeks") +
  theme_minimal()

## Looking at Seasons #################################################################
mc %>% 
  group_by(season) %>% 
  ggplot(aes(x = season)) +
  geom_bar(fill = c("#F5D46D", "#70E17C", "#F57D6D", "#43A0E8")) +
  labs(x = "Season",
       y = "Count",
       title = "Distribution of Seasons")

mc %>% 
  group_by(season) %>% 
  count()

merged_clean %>% 
  mutate(Spring = count)
  filter(season_Spring == 1)

merged_clean %>% 
  filter(season_Summer == 1)




## Looking at Death Distributions ######################################################

mc %>% 
  ggplot(aes(x = log(covid_19_deaths))) +
  geom_histogram(fill = "#43A0E8", color = 'white') +
  theme_minimal()

mc %>% 
  group_by(region) %>% 
  ggplot(aes(x = (covid_19_deaths))) +
  geom_histogram()


