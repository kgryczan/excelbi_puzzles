library(tidyverse)
library(readxl)

path = "Excel/099 Continuous Growth.xlsx"
input = read_excel(path, range = "A1:C17")
test  = read_excel(path, range = "E2:F4")

result = input %>%
  mutate(growth = Sales/lag(Sales,1) - 1, 
         n = n() - 1, 
         .by = Company) %>%
  na.omit() %>%
  summarise(average_growth = round(sum(growth, na.rm = TRUE)/n,2),
            is_stable = any(growth < 0),
            .by = Company) %>%
  distinct() %>%
  filter(is_stable == F) %>%
  select(-is_stable)

all.equal(result, test, check.attributes = F)
#> [1] TRUE