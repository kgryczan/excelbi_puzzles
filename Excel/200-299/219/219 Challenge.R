library(tidyverse)
library(readxl)

path = "Excel/219 Number of 7s.xlsx"
input = read_excel(path, range = "A1:A6")
test  = read_excel(path, range = "B1:B6")

result = input %>%
  mutate(seq = map(Number, ~ seq(1, .x))) %>%
  mutate(seq = map_chr(seq, ~ paste(.x, collapse = ""))) %>%
  mutate(n = str_count(seq, "7")) 
  
all.equal(result$n, test$`Answer Expected`)
#> [1] TRUE