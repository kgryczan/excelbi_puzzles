library(tidyverse)
library(readxl)
library(primes)

path = "Excel/024 Prime Numbers.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B5")

result = input %>%
  filter(is_prime(Number)) 

identical(result$Number, test$Answer)
# [1] TRUE