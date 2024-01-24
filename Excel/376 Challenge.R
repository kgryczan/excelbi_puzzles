library(tidyverse)
library(readxl)

test = read_excel("Excel/376 Mult of Lucas and Fibonacci.xlsx", range = "A1:A21") %>%
  pull(`Answer Expected`)

generate_sequence = function(n, first = 1, second = 1) {
  if (n == 1)
    return(first)
  if (n == 2)
    return(c(first, second))
  
  sequence = reduce(rep(1, n - 2), function(x, y) {
    c(x, sum(tail(x, 2)))
  }, .init = c(first, second))
  
  return(sequence)
}

fib = generate_sequence(20, 0, 1)
lucas = generate_sequence(20, 2, 1)

result = tibble(fib = fib,
                lucas = lucas,
                ratio = lucas * fib) %>%
  pull(ratio)

identical(result, test)
# [1] TRUE
