library(tidyverse)
library(readxl)

input = read_excel("Power Query/PQ_Challenge_143.xlsx", range = "A1:C21")
test  = read_excel("Power Query/PQ_Challenge_143.xlsx", range = "F1:H7")

result = input %>%
  group_by(Emp, Value) %>%
  mutate(rn = row_number()) %>%
  filter(rn == 2 | (rn == max(rn) & rn > 2)) %>%
  select(-rn) %>%
  ungroup()

identical(result, test)
#> [1] TRUE

#test_action
