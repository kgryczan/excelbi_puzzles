library(tidyverse)
library(readxl)
library(janitor)

input1 = read_excel("Power Query/PQ_Challenge_186.xlsx", range = "A1:A30") %>% clean_names()
input2 = read_excel("Power Query/PQ_Challenge_186.xlsx", range = "C1:D7") %>% clean_names()
test   = read_excel("Power Query/PQ_Challenge_186.xlsx", range = "F1:H30") %>% clean_names()

marked_dates <- input2 %>%
  mutate(
    preceding_date = delivery_date - days(1),
    following_date = delivery_date + days(1)
  ) %>%
  pivot_longer(
    cols = c(preceding_date, delivery_date, following_date),
    names_to = "type",
    values_to = "marked_date"
  ) %>%
  mutate(type = factor(type, levels = c("preceding_date", "following_date","delivery_date"), 
                       ordered = TRUE))

calendar_with_markings <- input1 %>%
  left_join(marked_dates, by = c("calendar_date" = "marked_date")) %>%
  mutate(marked = !is.na(vendor)) %>%
  group_by(calendar_date) %>%
  mutate(proper_type = max(type, na.rm = TRUE)) %>%
  ungroup() %>%
  filter(proper_type == type | is.na(proper_type)) %>%
  mutate(delivery_date = case_when(
    type == "delivery_date" ~ calendar_date,
    type == "preceding_date" ~ calendar_date + days(1),
    type == "following_date" ~ calendar_date - days(1)
  )) %>%
  select(calendar_date, delivery_date, vendor)

identical(test, calendar_with_markings)
# [1] TRUE