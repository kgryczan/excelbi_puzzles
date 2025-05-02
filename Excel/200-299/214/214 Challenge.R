library(tidyverse)
library(readxl)
library(numbers)

path = "Excel/214 CoPrime Numbrs.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B5")

gcs_vec = function(x) {reduce(x, GCD)}

result = input %>%
  mutate(Numbers1 = str_split(Numbers, ", ", )) %>%
  mutate(Numbers1 = map(Numbers1, ~ as.numeric(.x))) %>%
  mutate(GCD = map_dbl(Numbers1, gcs_vec)) %>%
  filter(GCD == 1) %>%
  select(Numbers) 

all.equal(result$Numbers, test$`Answer Expected`)
#> [1] TRUE