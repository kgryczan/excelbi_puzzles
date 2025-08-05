library(tidyverse)
library(readxl)

path = "Excel/700-799/775/775 Pivot.xlsx"
input = read_excel(path, range = "A2:B15")
test  = read_excel(path, range = "D2:F8")

result = input %>%
  mutate(group = cumsum(Value1 == "Org")) %>%
  group_by(group) %>%
  mutate(row = row_number()) %>%
  pivot_wider(names_from = Value1, values_from = Value2) %>%
  fill(Org, Product, .direction = "down") %>%
  fill(Product, Version, .direction = "up") %>%
  ungroup() %>%
  select(-group, -row) %>%
  distinct()

all.equal(result, test, check.attributes = FALSE)
# > [1] TRUE