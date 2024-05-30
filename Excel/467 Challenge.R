library(tidyverse)
library(readxl)

input = read_excel("Excel/467 Overlapping Times.xlsx", range = "A1:C8")
test  = read_excel("Excel/467 Overlapping Times.xlsx", range = "E2:L9") %>%
  select(`Task ID` = ...1, everything())

r1 = input %>%
  mutate(interval = interval(`From Time`, `To Time`)) %>%
  select(-`From Time`, -`To Time`) 

combinations = expand_grid(r1, r1, .name_repair = "unique") %>%
  filter(`Task ID...1` != `Task ID...3`) %>%
  mutate(overlap = ifelse(int_overlaps(interval...2, interval...4), "Y", NA_character_)) %>%
  select(`Task ID` = `Task ID...1`, `Second Task ID` = `Task ID...3`, overlap) %>%
  pivot_wider(names_from = `Second Task ID`, values_from = overlap) %>%
  select(`Task ID`, sort(colnames(.)))

identical(test, combinations)
# [1] TRUE