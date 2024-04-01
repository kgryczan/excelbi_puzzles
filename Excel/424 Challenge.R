library(tidyverse)
library(readxl)

input = read_excel("Excel/424 Insert In Between Multiplication.xlsx", range = "A1:A10")
test  = read_excel("Excel/424 Insert In Between Multiplication.xlsx", range = "B1:B10")

transform_number = function(number){
  str_number = as.character(number)
  digits = strsplit(str_number, "")[[1]] %>% as.numeric()
  ndigits = length(digits)
  products = map(1:(ndigits - 1), ~{
    digits[.x] * digits[.x+1]
  }) %>% c(., "")
  result = map2(digits,products,  ~{
    c(.x, .y)
  }) %>% unlist() %>%
    paste(collapse = "")
  return(result)
}

result = input %>%
  mutate(`Answer Expected` = map_chr(Words, transform_number)) %>%
  select(-Words)

identical(result, test)
# [1] TRUE
