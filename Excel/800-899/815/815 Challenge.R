library(tidyverse)
library(readxl)

path = "Excel/800-899/815/815 Unpivot.xlsx"
input = read_excel(path, range = "A2:F8")
test  = read_excel(path, range = "H2:I11")

result = input %>%
  fill(Product) %>%
  pivot_longer(-c(Product, Data), names_to = "Purchase", values_to = "Value", values_drop_na = T) %>%
  pivot_wider(names_from = Data, values_from = Value) %>%
  transmute(Product, Amount = Price * Quantity)

all.equal(result, test)
# [1] TRUE