library(tidyverse)
library(readxl)

path = "Excel/113 Sort Rows.xlsx"
input = read_excel(path, range = "A1:F9")
test  = read_excel(path, range = "A13:F21")

result = input %>%
  pivot_longer(cols = -Planets, names_to = "Month", values_to = "Value") %>%
  arrange(Value) %>%
  select(-Month) %>%
  mutate(rn = row_number(), .by = Planets) %>%
  pivot_wider(names_from = rn, values_from = Value) %>%
  arrange(Planets)

names(result) = names(test)

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE