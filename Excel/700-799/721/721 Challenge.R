library(tidyverse)
library(readxl)
library(arrangements)
library(primes)

path = "Excel/700-799/721/721 Prime_number_5digit.xlsx"
test = read_excel(path, range = "A1:A62")

perms <- permutations(1:9, 5) %>%
  as.data.frame() %>%
  unite("number", everything(), sep = "")

res <- perms %>%
  mutate(
    last4 = as.numeric(substr(number, 2, 5)),
    last3 = as.numeric(substr(number, 3, 5)),
    last2 = as.numeric(substr(number, 4, 5)),
    last1 = as.numeric(substr(number, 5, 5)),
    number = as.numeric(number)
  ) %>%
  filter(
    is_prime(last4) &
      is_prime(last3) &
      is_prime(last2) &
      is_prime(last1) &
      is_prime(number)
  ) %>%
  select(number)

all.equal(test, res, check.attributes = FALSE)
# [1] TRUE
