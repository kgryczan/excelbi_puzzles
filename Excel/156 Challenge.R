library(tidyverse)
library(readxl)

path = "Excel/156 Pythagorean Dates.xlsx"
test  = read_excel(path, range = "A1:A13")

dates = seq(as.Date("2000-01-01"), as.Date("2099-12-31"), by = "days") %>%
  tibble(value = .) %>%
  mutate(year = year(value) %% 100, month = month(value), day = day(value)) %>%
  mutate(across(c(year, month, day), ~ .x ^ 2)) %>%
  mutate(is_pythagorean = year == month + day) %>%
  filter(is_pythagorean) %>%
  select(value) %>%
  mutate(value = str_remove_all(as.character(value), "-"))

all.equal(dates$value, test$`List of Dates`)
#> [1] TRUE