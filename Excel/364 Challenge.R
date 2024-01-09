library(tidyverse)
library(readxl)

input = read_excel("Excel/364 Difference Consecutive Digits.xlsx", range = "A1:A10")
test  = read_excel("Excel/364 Difference Consecutive Digits.xlsx", range = "B1:B6")

check_seq_diff = function(x) {
  digits = as.character(strsplit(as.character(x), "")[[1]])
  diffs = map2_dbl(digits[-length(digits)], 
                   digits[-1], 
                   ~abs(as.numeric(.x) - as.numeric(.y)))
  all(diffs == 1:length(diffs))
}

result = input %>%
  mutate(test = map_lgl(Number, check_seq_diff)) %>%
  filter(test) %>%
  select(-test)

identical(result$Number, test$`Answer Expected`)
# [1] TRUE
