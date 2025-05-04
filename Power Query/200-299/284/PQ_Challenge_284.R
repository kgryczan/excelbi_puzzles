library(tidyverse)
library(readxl)

path = "Power Query/200-299/284/PQ_Challenge_284.xlsx"
input = read_excel(path, range = "A1:D20")
test = read_excel(path, range = "F1:J6")

result = input %>%
  pivot_longer(everything(), names_to = "name", values_to = "value") %>%
  mutate(
    bin = cut(value, breaks = seq(0, 100, by = 20), include.lowest = TRUE)
  ) %>%
  pivot_wider(
    names_from = name,
    values_from = value,
    values_fn = list(value = sum)
  ) %>%
  arrange(bin)
