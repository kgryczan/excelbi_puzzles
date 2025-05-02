library(tidyverse)
library(readxl)

input = read_excel("Excel/395 Connected Points.xlsx", range = "A1:D8")
test  = read_excel("Excel/395 Connected Points.xlsx", range = "E1:E8")

result = input %>%
  mutate(figure = row_number()) %>%
  pivot_longer(-figure, names_to = "Coord", values_to = "value") %>%
  separate(value, into = c("x", "y"), sep = ", ") %>%
  group_by(figure) %>%
  mutate(is_connected = ifelse(x == lag(y), "Yes", "No")) %>%
  na.omit(is_connected) %>%
  summarise(`Answer Expected` = ifelse(all(is_connected == "Yes"), "Yes", "No")) %>%
  select(-figure) %>%
  ungroup()

identical(result, test)
# [1] TRUE
