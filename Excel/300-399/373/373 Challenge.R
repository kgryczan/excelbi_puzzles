library(tidyverse)
library(readxl)

input = read_excel("Excel/373 Count Digits in Squares.xlsx", range = "A1:C10")
test  = read_excel("Excel/373 Count Digits in Squares.xlsx", range = "D1:D10")

count_digits = function(x, y, digit) {
  s = seq(x, y)
  sq = s^2
  u = unlist(strsplit(as.character(sq), ""))
  n = sum(u == digit)
  return(n)
}

result = input %>%
  mutate(count = pmap_int(list(N1, N2, D), count_digits)) %>%
  bind_cols(test) %>%
  mutate(check = count == `Answer Expected`)

result
