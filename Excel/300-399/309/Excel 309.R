library(tidyverse)
library(readxl)
library(stringr)
library(data.table)

input = read_excel("ISBN10 to ISBN13 Conversion.xlsx", range ="A1:A10")
test = read_excel("ISBN10 to ISBN13 Conversion.xlsx", range ="B1:B10") 

convert_isbn <- function(isbn) {
  isbn_base <- paste0('978', str_sub(isbn, 1, 9))
  digits <- as.integer(unlist(str_split(isbn_base, "")))
  multipliers <- map_dbl(seq_along(digits), ~if_else(.x %% 2 == 1, 1, 3))
  
  sum_products <- sum(map2_dbl(digits, multipliers, ~ .x * .y))
  check_digit <- (10 - (sum_products %% 10)) %% 10
  isbn13 = paste0(isbn_base, check_digit)
  
  return(isbn13)
}


result = input %>%
  mutate(isbn13 = map_chr(ISBN10, convert_isbn))

identical(test$`ISBN13 Answer Expected`, result$isbn13)
#> [1] TRUE