library(tidyverse)
library(readxl)
library(gmp)

path = "Excel/519 Sum of Digits of Number, Square and Cube are Same.xlsx"
test = read_excel(path, range = "A1:A26")


digit_sum <- function(x) {
  sum(as.integer(unlist(strsplit(as.character(x), ""))))
}

x <- 9
results <- tibble(x = numeric(), n = numeric(), s = numeric(), c = numeric())

while (nrow(results) < 25) {
  n <- digit_sum(x)
  s <- digit_sum(as.bigz(x)^2)
  c <- digit_sum(as.bigz(x)^3)
  
  if (n == s && n == c) {
    results <- results %>% add_row(x = x, n = n, s = s, c = c)
  }
  
  x <- x + 1
}

identical(results$x, test$`Answer Expected`)
#> [1] TRUE