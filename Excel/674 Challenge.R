library(tidyverse)
library(readxl)

path = "Excel/674  Consecutive Numbers.xlsx"
input = read_excel(path, range = "A1:A14")
test  = read_excel(path, range = "B2:E5", col_names = c("1","2","3","4"))

result = input %>%
  mutate(n = consecutive_id(Numbers)) %>%
  group_by(n) %>%
  filter(n() > 1) %>%
  mutate(rn = row_number()) %>%
  pivot_wider(names_from = n, values_from = Numbers) %>%
  select(-rn)

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE