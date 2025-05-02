library(tidyverse)
library(readxl)

input = read_excel("Excel/365 One digit is Equal to Sum of other Digits.xlsx", range = "A1:A10")
test  = read_excel("Excel/365 One digit is Equal to Sum of other Digits.xlsx", range = "B1:B5")

evaluate = function(number) {
  digits = as.numeric(unlist(strsplit(as.character(number), "")))
  check  = purrr::map_lgl(digits, ~ .x == sum(digits[-which(digits == .x)]))
  return(any(check))
}

result = input %>%
  mutate(eval = map_lgl(Number, evaluate)) %>%
  filter(eval) %>%
  select(`Answer Expected` = Number)

identical(result, test)
