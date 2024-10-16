library(tidyverse)
library(readxl)

path = "Excel/566 Count in Columns.xlsx"
input = read_excel(path, range = "A2:C14")
test  = read_excel(path, range = "E2:J6")

result = input %>%
  pivot_longer(everything(), names_to = "basket", values_to = "fruit") %>%
  summarise(Count = n(), .by = c(fruit, basket)) %>%
  na.omit() %>%
  pivot_wider(names_from = Count,
              values_from = basket, 
              values_fn = list(basket = ~ str_c(sort(.x), collapse = ", "))) %>%
  arrange(fruit) %>%
  select(Count = fruit,`1`, `2`, `3`, `4`, `5`) 

all.equal(result, test, check.attributes = FALSE)
# [1] TRUE
