library(tidyverse)
library(readxl)

input = read_excel("Power Query/PQ_Challenge_152.xlsx", range = "A1:D17") %>%
  janitor::clean_names()
test  = read_excel("Power Query/PQ_Challenge_152.xlsx", range = "F1:I5") %>%
  janitor::clean_names()

result = input %>%
  mutate(seq = map2(from_date, to_date, seq, by = "day")) %>%
  unnest_longer(seq) %>%
  select(-c(from_date, to_date)) %>%
  mutate(value = 1) %>%
  pivot_wider(names_from = type_of_leave, values_from = value, values_fill = 0) %>%
  select(name, seq, ML, PL, CL) %>%
  mutate(sum = ML + PL + CL,
         concat = paste0(ML, PL, CL) %>% as.numeric(),
         main_leave = case_when(sum == 1 & ML == 1 ~ "ML",
                                sum == 1 & PL == 1 ~ "PL",
                                sum == 1 & CL == 1 ~ "CL",
                                sum == 2 & concat >= 100 ~ "ML",
                                sum == 2 & concat < 100 ~ "PL",
                                sum == 3 ~ "ML",
                                TRUE ~ "NA"),
         wday = wday(seq, week_start = 1)) %>%
  filter(!wday %in% c(6, 7)) %>%
  select(name, seq, main_leave) %>%
  mutate(main_leave = str_to_lower(main_leave)) %>%
  group_by(name, main_leave) %>%
  summarise(days = n() %>% as.numeric()) %>%
  ungroup() %>%
  pivot_wider(names_from = main_leave, values_from = days, values_fill = 0)

identical(result, test)
#> [1] TRUE
