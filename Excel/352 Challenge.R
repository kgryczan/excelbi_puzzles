library(tidyverse)
library(readxl)
library(numbers)

input = read_excel("Excel/352 Interprime Numbers.xlsx", range = "A1:A10") %>% janitor::clean_names()
test  = read_excel("Excel/352 Interprime Numbers.xlsx", range = "B1:B6") %>% janitor::clean_names()

# Version using ready numbers package functions
is_interprime <- function(n) {
  if (!is.integer(n)) {return(FALSE)}
  prev_prime <- previousPrime(n)
  next_prime <- nextPrime(n)
  return(n == (prev_prime + next_prime) / 2)
}

# version with own functions (we are gonna use only is_prime from numbers package)  
next_prime = function(n) {
  repeat {
    n = n + 1
    if (isPrime(n)) {return(n)}
  }
}
previous_prime = function(n) {
  while (n > 2) {
    n = n - 1
    if (isPrime(n)) {return(n)}
  }
}
is_interprime_2 <- function(n) {
  if (!is.integer(n)) {return(FALSE)}
  prev_prime <- previous_prime(n)
  next_prime <- next_prime(n)

  return(n == (prev_prime + next_prime) / 2)
}

result = input %>%
  mutate(number = as.integer(number)) %>%
  mutate(is_interprime = map_lgl(number, is_interprime),
         is_interprime_2 = map_lgl(number, is_interprime_2)) %>%
  filter(is_interprime) %>%
  bind_cols(test)

identical(as.numeric(result$number), result$answer_expected)
