library(tidyverse)
library(readxl)

path = "Excel/101 Sum After Division.xlsx"
input = read_excel(path, range = "A1:A7")
test  = read_excel(path, range = "B1:B7")

divide_by_7_and_round = function(x, ...) {
  return(ceiling(x / 7))
}

accumulate_while <- function(n) {
  result <- accumulate(1:100, divide_by_7_and_round, .init = n)
  result <- result[-1][seq_len(match(1, result[-1]))]
  result = sum(result)
  return(result)
}

result = input %>%
  mutate(Sum = map_dbl(Number, accumulate_while))

all.equal(result$Sum, test$Sum)
#> [1] TRUE