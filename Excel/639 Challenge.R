library(tidyverse)
library(readxl)
library(hms)

path = "Excel/639 Total Hours Per Day.xlsx"
input = read_excel(path, range = "A1:H6")
test  = read_excel(path, range = "A9:B16")

result = input %>%
  pivot_longer(cols = -Name, names_to = "Day", values_to = "Hours") %>%
  separate(Hours, into = c('from', 'to'), sep = '-') %>%
  na.omit() %>%
  mutate(across(c(from, to), ~ parse_date_time(paste0(substr(., 1, 2), ":", substr(., 3, 4)), orders = "HM"))) %>%
  mutate(hours = as.numeric(difftime(to, from, units = "hours"))) %>%
  summarise(`Total Hours` = sum(hours), .by = Day)

all.equal(result, test)
#> [1] TRUE