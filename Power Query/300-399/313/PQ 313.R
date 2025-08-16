library(tidyverse)
library(readxl)
library(janitor)

path = "Power Query/300-399/313/PQ_Challenge_313.xlsx"
input = read_excel(path, range = "A1:B18")
test  = read_excel(path, range = "D1:E5")

result = input %>%
  mutate(group = cumsum(Data1 == "Customer")) %>%
  pivot_wider(
    names_from = Data1,
    values_from = Data2,
    values_fill = NA
  ) %>%
  mutate(across(-c(group, Customer), as.numeric)) %>%
  mutate(`Total Amount` = Quantity * (Price -rowSums(across(starts_with("Disc")), na.rm = T) - rowSums(across(starts_with("Tax")), na.rm = T))) %>%
  select(Customer, `Total Amount`) %>%
  adorn_totals("row", name = "Total Sale")
  
all.equal(result, test, check.attributes = FALSE) 
# > TRUE  