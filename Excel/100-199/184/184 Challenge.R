library(tidyverse)
library(readxl)

path = "Excel/184 Five Fri Sat Sun.xlsx"
test  = read_excel(path, range = "A1:A14")

days = data.frame(dates = seq.Date(as.Date("2000-01-01"), as.Date("2099-12-31"), by = "days")) %>% 
  mutate(wday = wday(dates, week_start = 1),
         month = month(dates),
         year = year(dates)) %>%
  filter(wday %in% c(5, 6, 7)) %>%
  summarise(n = n(), .by = c(month, year, wday)) %>%
  mutate(month_has_fives = all(n == 5), .by = c(month, year)) %>%
  filter(month_has_fives) %>%
  select(year, month) %>%
  distinct() %>%
  summarise(n = n(), .by = c(year)) %>%
  filter(n == 2) %>%
  select(-n)

all.equal(test, days, check.attributes = FALSE)
#> [1] TRUE