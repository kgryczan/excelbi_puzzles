library(tidyverse)
library(readxl)
library(numbers)

path = "Excel/149 Perfect Numbers.xlsx"
input = read_excel(path, range = "A1:A12")
test  = read_excel(path, range = "B1:B8")

is_perfect = function(n) {
  divisors = numbers::divisors(n)
  divisors = divisors[1:(length(divisors) - 1)]
  return(sum(divisors) == n)
  }

result = input %>%
  mutate(is_perfect = map_lgl(Numbers, is_perfect)) %>%
  filter(is_perfect)

all.equal(result$Numbers, test$`Answer Expected`)
# [1] TRUE