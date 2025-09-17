library(tidyverse)
library(readxl)
library(primes)

path = "Excel/300-399/303/303 All Primes After Removal Single Digits.xlsx"
input = read_excel(path, range = "A1:A10")
test = read_excel(path, range = "B1:B5")

primes_inside = function(n){
  vec = str_split(as.character(n), "")[[1]]
  res = map(1:length(vec), ~ as.numeric(paste0(vec[-c(.x)], collapse = "")))
  x = map_lgl(res, is_prime) %>% all()
}

result = input %>%
  mutate(my_answer = map_lgl(Numbers, primes_inside)) %>%
  filter(my_answer)

identical(result$Numbers, test$`Expected Answer`)
#> [1] TRUE