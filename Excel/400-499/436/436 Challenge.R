library(tidyverse)
library(readxl)
library(primes)
library(gtools)

test = read_excel("Excel/436 Pandigital Primes.xlsx", range = "A1:A101")

generate_pandigital = function(n) {
  digits = 1:n
  digits = permutations(n,n) 
  digits = apply(digits, 1, function(x) as.numeric(paste(x, collapse = "")))
  return(digits)
}

df = data.frame(numbers = NA)

for (i in 1:7) {
  pandigitals = generate_pandigital(i)
  df = rbind(df, data.frame(numbers = pandigitals))  
}

result = df %>%
  mutate(is_prime = map_lgl(numbers, is_prime)) %>%
  filter(is_prime) %>%
  head(100)

identical(result$numbers, test$`Answer Expected`)
# [1] TRUE
