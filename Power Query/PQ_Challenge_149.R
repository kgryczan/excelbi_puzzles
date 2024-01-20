library(tidyverse)
library(readxl)

input = read_excel("Power Query/PQ_Challenge_149.xlsx", range = "A1:D6") %>%
  janitor::clean_names()
test  = read_excel("Power Query/PQ_Challenge_149.xlsx", range = "F1:I12") %>%
  janitor::clean_names() %>% 
  arrange(employee, start_date)

result = input %>%
  mutate(days = map2(start_date, end_date, ~ seq(.x, .y, by = "day"))) %>%
  unnest(days) %>%
  mutate(month = floor_date(days, "month")) %>%
  select(-start_date, -end_date) %>%
  group_by(employee, per_diem, month) %>%
  summarise(n_days = n(),
            start_date = min(days),
            end_date = max(days)) %>%
  ungroup() %>%
  mutate(total = n_days * per_diem) %>%
  select(employee, start_date, end_date, per_diem = total) %>%
  arrange(employee, start_date)

identical(result, test)
#> [1] TRUE
