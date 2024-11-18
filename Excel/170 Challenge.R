library(tidyverse)
library(readxl)
library(primes)
library(stringi)

path = "Excel/170 Reversed Primes.xlsx"
input = read_excel(path, range = "A1:A9")
test  = read_excel(path, range = "B1:B9") %>%
  na.omit()

reverse_number = function(x) {
  x = as.character(x)
  x = stri_reverse(x)
  x = as.numeric(x)
  return(x)
}

result = input %>%
  filter(is_prime(Number) & is_prime(reverse_number(Number)))

all.equal(result$Number, test$`Answer Expected`)
#> [1] TRUE