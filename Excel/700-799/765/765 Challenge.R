library(tidyverse)
library(readxl)

path = "Excel/700-799/765/765 Pivot.xlsx"
input = read_excel(path, range = "A2:B9")
test  = read_excel(path, range = "D2:H5")

result = input %>%
  separate_longer_delim(Items, ", ") %>%
  separate_wider_delim(Items, ": ", names = c("Item", "Quantity")) %>%
  mutate(Quantity = as.numeric(Quantity)) %>%
  pivot_wider(names_from = Item, values_from = Quantity, values_fn = sum) %>%
  select(Supplier, sort(names(.), decreasing = F)) 

# DFs are not equal
