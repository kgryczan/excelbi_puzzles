library(tidyverse)
library(readxl)

path = "Excel/086 Align Cities.xlsx"
input = read_excel(path, range = "A1:B20")
test  = read_excel(path, range = "D2:G9")

result = input %>% 
  mutate(rn = row_number(), .by = City) %>%
  pivot_wider(names_from = City, values_from = Names) %>%
  select(-rn)

identical(result, test)
#> [1] TRUE