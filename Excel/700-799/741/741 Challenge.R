library(tidyverse)
library(readxl)

path = "Excel/700-799/741/741 Pivot.xlsx"
input = read_excel(path, range = "A2:A10")
test = read_excel(path, range = "C2:F5")

result = input %>%
  mutate(
    Item = str_extract(Data, "Item\\d+"),
    Group = str_extract(Data, "(?<=Group )\\w")
  ) %>%
  mutate(Data = str_remove_all(Data, "Item\\d+|Group [ABC]")) %>%
  mutate(Data = str_extract_all(Data, "\\d+")) %>%
  mutate(Data = map_dbl(Data, ~ sum(as.numeric(.)))) %>%
  summarise(Total = sum(Data), .by = c("Item", "Group")) %>%
  pivot_wider(names_from = Item, values_from = Total)

all.equal(test, result, check.attributes = FALSE)
#> [1] TRUE
