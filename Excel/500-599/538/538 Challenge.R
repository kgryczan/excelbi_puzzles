library(tidyverse)
library(readxl)
library(primes)
library(stringi)

path = "Excel/538 Emirps.xlsx"
test = read_excel(path)

is_palindrome = function(x) {
  x = as.character(x)
  x == stri_reverse(x)
}

max_val = 10000000
primes = generate_n_primes(max_val)
primes = primes[primes > 10]
non_pal_primes = primes[!is_palindrome(primes)]

nums = data.frame(number = 1:10000000) %>%
  filter(number %in% non_pal_primes & stri_reverse(as.character(number)) %in% non_pal_primes)

all.equal(nums$number, test$`Expected Answer`) # TRUE
