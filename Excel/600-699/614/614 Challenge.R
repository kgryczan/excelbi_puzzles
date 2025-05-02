library(tidyverse)
library(readxl)

path = "Excel/614 Consecutive Numbers Count.xlsx"
input = read_excel(path, range = "A1:A20")
test  = read_excel(path, range = "B1:B20")

result = input %>%
  mutate(group = consecutive_id(Problem)) %>%
  mutate(`Answer Expected` = ifelse(n() >= 2, n(), NA), .by = group) %>%
  select(`Answer Expected`)

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE