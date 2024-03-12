library(tidyverse)
library(readxl)
library(stringi)

input = read_excel("Excel/410 Palindromic Roman Numerals.xlsx", range = "A2:A10")
test  = read_excel("Excel/410 Palindromic Roman Numerals.xlsx", range = "B2:C5")


to_roman <- function(number) {
  if (!is.numeric(number) || number <= 0 || number != as.integer(number)) {
    return(NA)
  }
  
  roman_symbols <- c("M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I")
  arabic_values <- c(1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1)
  
  numeral <- ""
  for (i in seq_along(roman_symbols)) {
    while (number >= arabic_values[i]) {
      numeral <- paste0(numeral, roman_symbols[i])
      number <- number - arabic_values[i]
    }
  }
  
  return(numeral)
}

is_palindrome = function(string) {
  string == stri_reverse(string)
}

result = input %>%
  mutate(roman = map_chr(`Decimal Number`, to_roman)) %>%
  mutate(palindrome = map_lgl(roman, is_palindrome)) %>%
  filter(palindrome) %>%
  select(`Decimal Number`, `Roman Number` = roman)

identical(result, test)
# [1] TRUE
