library(tidyverse)
library(readxl)

path = "Excel/623 Sum of Numbers Across Diagonals of 3 Columns.xlsx"
input = read_excel(path, range = "A1:C19") %>% as.matrix()
test  = read_excel(path, range = "E1:E2") %>% pull()


construct_zigzag <- function(n, width = 3) {
  repeating_block <- c(1:width, (width - 1):2)
  rep_len(repeating_block, n)
}

zigzag = construct_zigzag(nrow(input))
result = sum(input[cbind(1:nrow(input), zigzag)])

test == result
#> [1] TRUE
