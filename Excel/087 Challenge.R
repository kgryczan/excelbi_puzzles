library(tidyverse)
library(readxl)

path = "Excel/087 Highest Growth.xlsx"
input = read_excel(path, range = "A1:C17")
test  = read_excel(path, range = "E2:F3")

result = input %>%
  mutate(growth = (Sales/lag(Sales)) - 1, .by = Region) %>%
  slice_max(growth, n = 1) %>%
  select(Region, Year)

identical(result, test)
#> [1] TRUE