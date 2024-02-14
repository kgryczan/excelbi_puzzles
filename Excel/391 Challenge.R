library(tidyverse)
library(readxl)
library(stringi)

input = read_excel("Excel/391 Palindrome After Adding in the Beginning.xlsx", range = "A1:A10")
test  = read_excel("Excel/391 Palindrome After Adding in the Beginning.xlsx", range = "B1:B10")

is_palindrome = function(x) {
  x = tolower(x)
  x == stri_reverse(x)
}

palindromize = function(string) {
  if (is_palindrome(string)) {
    return(string)
  }
  
  string_rev = stri_reverse(string)

  prefixes = map(1:nchar(string), function(i) {
    substr(string_rev, 1, i)
  })
  candidates = map(prefixes, function(prefix) {
    paste0(prefix, string)
  })
  
  palindromes = data.frame(candidate = unlist(candidates)) %>%
    mutate( is_palindrome = map_lgl(candidate, is_palindrome)) %>%
    filter(is_palindrome) %>%
    select(candidate) %>%
    arrange(nchar(candidate)) %>%
    slice(1) %>%
    pull()
    
  return(palindromes)
}

result = input %>%
  mutate(palindromized = map_chr(String, palindromize)) %>%
  cbind(test) %>%
  mutate(check = palindromized == `Answer Expected`)

