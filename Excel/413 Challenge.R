library(tidyverse)
library(readxl)

input = read_excel("Excel/413 Pivot.xlsx", range = "A1:B15")
test  = read_excel("Excel/413 Pivot.xlsx", range = "D1:I5")

result = input %>%
  group_by(ID) %>%
  mutate(rn = row_number()) %>%
  pivot_wider(names_from = rn, names_prefix = "Num ", values_from = Num) %>%
  ungroup() %>%
  arrange(ID)

identical(result, test)
# [1] TRUE
