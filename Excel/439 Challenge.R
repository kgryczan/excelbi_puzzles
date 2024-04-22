library(tidyverse)
library(readxl)

input = read_excel("Excel/439 - Bilinear Interpolation.xlsx", range = "A1:B5")
lookup = read_excel("Excel/439 - Bilinear Interpolation.xlsx", range = "E1:M7")
test = read_excel("Excel/439 - Bilinear Interpolation.xlsx", range = "C1:C5")

lookup = lookup %>%
  column_to_rownames("a/b")

bilinear_interpolation = function(a, b, lookup_table) {
  a_low = floor(a * 10) / 10
  a_high = ceiling(a * 10) / 10
  b_low = floor(b)
  b_high = ceiling(b)
  
  dist_a = a_high - a_low
  dist_b = b_high - b_low
  
  vlook_1 = lookup_table[as.character(b_low), as.character(a_low)]
  vlook_2 = lookup_table[as.character(b_high), as.character(a_low)]
  vlook_3 = lookup_table[as.character(b_low), as.character(a_high)]
  
  x_1 = if_else(dist_b == 0, 0, (vlook_2 - vlook_1) * (b - b_low) / dist_b)
  x_2 = if_else(dist_a == 0, 0, (vlook_3 - vlook_1) * (a - a_low) / dist_a)
  
  value = vlook_1 + x_1 + x_2
  return(round(value, 3))
}

result = input %>%
  mutate(`Answer Expected` = map2_dbl(a, b, ~bilinear_interpolation(.x, .y, lookup)))

identical(result$`Answer Expected`, test$`Answer Expected`)
# [1] TRUE
