library(tidyverse)
library(readxl)

path = "Excel/800-899/828/828 Group By.xlsx"
input = read_excel(path, range = "A2:A21")
test  = read_excel(path, range = "B2:F6")

result = input %>%
  mutate(cid = consecutive_id(Numbers)) %>%
  mutate(auxn = row_number(), .by = cid) %>%
  mutate(group = cumsum(auxn == 2) + 1) %>%
  filter(auxn == 1) %>%
  select(-c(cid, auxn)) %>%
  mutate(rn = row_number(), .by = group) %>%
  pivot_wider(names_from = group, values_from = Numbers, names_prefix = "Group") %>%
  select(-rn)

identical(result, test)
# [1] TRUE