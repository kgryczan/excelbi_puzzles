library(tidyverse)
library(readxl)
library(primes)

path = "Excel/222 Left Truncatable Primes.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B7")

contains_zero = function(x) {
  return(grepl("0", x))
}

is_left_truncatable_prime = function(x) {
  if (contains_zero(x)) {
    return(FALSE)
  }
  if (!is_prime(as.numeric(x))) {
    return(FALSE)
  }  
  x = as.character(x)
  for (i in seq_along(x)) {
    if (!is_prime(as.numeric(substr(x, i, nchar(x))))) {
      return(FALSE)
    }
  }
  return(TRUE)
}

result = input %>%
  mutate(is_valid = map_dbl(Numbers, is_left_truncatable_prime)) %>%
  filter(is_valid != 0)
