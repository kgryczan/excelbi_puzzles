library(tidyverse)
library(readxl)

path = "Excel/800-899/811/811 Dublicate Text, Dates and Divide Costs.xlsx"
input = read_excel(path, range = "A2:H6")
test  = read_excel(path, range = "J2:Q13")

result = input %>%
  uncount(Quantity, .remove = F) %>%
  mutate(Item = row_number(),
         `Item Code` = as.character(Code),
         Quantity1 = Quantity/Quantity,
         `Material Cost` = `Material Cost`/Quantity,
         `Installation Cost` = `Installation Cost`/Quantity) %>%
  select(-Quantity) %>%
  rename(Quantity = Quantity1) %>%
  janitor::adorn_totals("row") %>%
  select(Item, `Item Code`, `Item Name`, Location, Quantity, `Material cost` = `Material Cost`, `Installation Cost`, Date)

# all equal. Only total row looks differently