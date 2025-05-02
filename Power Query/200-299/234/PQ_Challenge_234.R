library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_234.xlsx"
input = read_excel(path, range = "A1:G5")
test  = read_excel(path, range = "A10:B14")

result = input %>%
  pivot_longer(-c(1), names_to = c(".value", "number"), names_pattern = "(.*)(\\d)") %>%
  na.omit() %>%
  mutate(seq = map2(StartDate, EndDate, ~seq.Date(from = as.Date(.x), to = as.Date(.y), by = "day"))) %>%
  unnest(cols = seq) %>%
  mutate(Weekday = wday(seq, week_start = 1)) %>%
  filter(Weekday %in% c(1:5)) %>%
  summarise(TotalLeaves = n_distinct(seq), .by = Employee) %>%
  arrange(Employee)

all.equal(result, test, check.attributes = FALSE)
# [1] TRUE