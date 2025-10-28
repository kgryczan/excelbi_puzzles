library(tidyverse)
library(readxl)

path = "Excel/800-899/835/835 Max Salary.xlsx"
input = read_excel(path, range = "A2:C12")
test  = read_excel(path, range = "E2:G6")

result = input %>%
  fill(Dept) %>%
  slice_max(order_by = Salary, n = 1, with_ties = T, by = Dept) %>%
  mutate(Dept = if_else(row_number() == 1, Dept, NA_character_), .by = Dept) %>%
  rename(`Max Salary` = Salary)

all.equal(result, test)
# [1] TRUE