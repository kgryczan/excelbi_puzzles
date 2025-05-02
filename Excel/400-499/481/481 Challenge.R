library(tidyverse)
library(readxl)
library(tictoc)

path = "Excel/481 Taxicab Numbers.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10")

tic()
is_taxicab = function(number) {
  x = ceiling(number^(1/3))

  df = tibble(a = 1:x, b = 1:x) %>%
    expand.grid() %>%
    filter(a <= b,
           a^3 + b^3 == number)
  check = ifelse(nrow(df) >= 2, "Y", "N")
  return(check)
}

result = input %>%
  mutate(`Answer Expected` = map_chr(Numbers, is_taxicab)) 
toc()
# 0.03 sec elapsed

identical(result$`Answer Expected`, test$`Answer Expected`)
# [1] TRUE