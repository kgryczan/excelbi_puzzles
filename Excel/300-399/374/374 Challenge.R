library(tidyverse)
library(readxl)
library(stringi)

input = read_excel("Excel/374 Palindrome After Removal.xlsx", range = "A1:A10")
test  = read_excel("Excel/374 Palindrome After Removal.xlsx", range = "B1:B10")

is_palindrome = function(word) {
  word == stri_reverse(word)
}

find_palindromes = function(string) {
  vec = str_split(string, "")[[1]]
  n = length(vec)
  possible_palindromes = map(1:n, ~ paste0(vec[-.x], collapse = "")) %>%
    unlist() %>%
    keep(is_palindrome)
  if (length(possible_palindromes) == 0) {
    return(NA_character_)
  }
  else{
  unique(possible_palindromes) %>% paste0(collapse = ", ")
  }
}

result = input %>%
  mutate(`Answer Expected` = map_chr(`Words`, find_palindromes))

all.equal(result$`Answer Expected`, test$`Answer Expected`)
#> [1] TRUE
