library(tidyverse)
library(readxl)

path = "Excel/048 Numbers in Increasing Order.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B5")

check_increasing_order = function(x){
  digits = as.numeric(unlist(strsplit(as.character(x), "")))
  diffs = diff(digits)
  return(all(diffs >= 0))
}

result = input %>%
  mutate(is_valid = map_lgl(Numbers, check_increasing_order)) %>%
  filter(is_valid) %>%
  select(-is_valid)

identical(result$Numbers, test$`Answer Expected`)
#> [1] TRUE