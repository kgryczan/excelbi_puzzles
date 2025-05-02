library(tidyverse)
library(readxl)
library(lubridate)
library(hms)

input = read_excel("Power Query/PQ_Challenge_150.xlsx", range = "A1:D11") %>%
  janitor::clean_names() 
test  = read_excel("Power Query/PQ_Challenge_150.xlsx", range = "F1:I11") %>%
  janitor::clean_names() %>% 
  mutate(across(c(time_in, time_out), ~as_hms(.x)))

result = input %>%
  mutate(across(c(time_in, time_out), ~as_hms(.x))) %>%
  group_by(empty = is.na(time_in)) %>%
  mutate(nr = row_number()) %>%
  ungroup() %>%
  group_by(nr) %>%
  mutate(time_in = if_else(empty, first(time_out), time_in),
         time_out = if_else(empty, time_in + dminutes(round(duration * 60,0)), time_out)) %>%
  ungroup() %>%
  select(-c(empty, nr))

identical(result, test)
#> [1] TRUE
