library(tidyverse)
library(readxl)
library(numbers)

input = read_excel("Excel/455 Anti perfect numbers.xlsx", range = "A1:A10")
test  = read_excel("Excel/455 Anti perfect numbers.xlsx", range = "B1:B5")

is_antiperfect = function(number) {
  divisors = divisors(number) 
  divisors = divisors[-length(divisors)]
  reversed_divisors = map(divisors, ~str_c(rev(str_split(.x, "")[[1]]), collapse = "")) %>%
    as.numeric()
  sum_rev_div = sum(reversed_divisors)
  return(sum_rev_div == number)
}

result = input %>%
  mutate(is_antiperfect = map_lgl(Numbers, is_antiperfect)) %>%
  filter(is_antiperfect) %>%
  select(`Expected Answer` = Numbers)

identical(result, test)
# [1] TRUE