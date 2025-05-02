library(tidyverse)
library(readxl)

input1 = read_excel("Excel/476 Assigning Sales.xlsx", range = "A2:B5")
input2 = read_excel("Excel/476 Assigning Sales.xlsx", range = "D2:E11")
test   = read_excel("Excel/476 Assigning Sales.xlsx", range = "G2:I11")

result = input1 %>%
  left_join(input2, by = "Store") %>%
  mutate(n = n(), .by = Store) %>%
  mutate(Sales = Sales / n) %>%
  select(Store, Branch, Sales)

identical(result, test)
# [1] TRUE