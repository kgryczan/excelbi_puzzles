library(tidyverse)
library(readxl)

path = "Excel/038 Same Salary.xlsx"
input = read_excel(path, range = "A1:B10")
test  = read_excel(path, range = "D2:E7")

result = input %>%
  mutate(group = ifelse(n() > 1, "Same Salary", "Not Same Salary"), .by = Salary) %>%
  select(-Salary) %>%
  arrange(group) %>%
  mutate(rn = row_number(), .by = group) %>%
  pivot_wider(names_from = group, values_from = Employees) %>%
  select(`Same Salary`, `Not Same Salary`)

identical(result, test)
#> [1] TRUE