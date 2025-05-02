library(tidyverse)
library(readxl)

input = read_excel("Excel/459 Next Perfect Square.xlsx", range = "A1:A10")
test  = read_excel("Excel/459 Next Perfect Square.xlsx", range = "B1:B10")

find_next_perf_square = function(n) (floor(sqrt(n)) + 1) ** 2

result = input %>%
  mutate(`Answer Expected` = map_dbl(Number, find_next_perf_square)) %>%
  select(-Number)

identical(result, test)
# [1] TRUE