library(tidyverse)
library(readxl)

path = "Excel/044 Pair Finding Lowest Difference.xlsx"
input = read_excel(path, range = "A1:B10")
test  = read_excel(path, range = "D2:E4")

result = input %>%
  mutate(diff = abs(Number1 - Number2)) %>%
  slice_min(diff, n = 1) %>%
  select(-diff)

identical(result, test)
#> [1] TRUE