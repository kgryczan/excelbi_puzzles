library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_275.xlsx"
input = read_excel(path, range = "A1:E7")
test  = read_excel(path, range = "G1:I7")

result = input %>%
  pivot_longer(
    cols = -Group,
    names_to = c(".value", "index"),
    names_pattern = "([A-Za-z]+)(\\d)"
  ) %>%
  select(-index) %>%
  summarise(Value = sum(Value), 
            Groups = paste0(Group, collapse = ", "), .by = Number) %>%
  arrange(Number) 


# GH09 should have two groupss in answeer