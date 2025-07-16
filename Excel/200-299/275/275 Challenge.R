library(tidyverse)
library(readxl)
library(stringi)

input = read_excel("Excel/200-299/275/275 Palindrome Words.xlsx") %>% select(1)

find_palindromes <- function(sentence) {
  words <- str_split(sentence, "\\s+|,\\s*")[[1]] # Tokenize = split sentence to words
  decap_words <- map_chr(words, str_to_lower) # De-capitalize words
  clean_words <- map_chr(decap_words, ~str_replace_all(.x, "[[:punct:][:space:]]", "")) # Clean spaces, periods and commas.
  filtered_words <- clean_words[nchar(clean_words) > 1] # Exclude one-character words
  
  rev_words <- map_chr(filtered_words, stri_reverse) # reverse strings
  check <- map2_lgl(filtered_words, rev_words, ~ .x == .y) # Compare words with reversed versions
  
  palindromes <- filtered_words[check] # Get only words with TRUE while checking
  return(palindromes)
}


result = input %>%
  rowwise() %>%
  mutate(Palindromes = list(find_palindromes(Sentences))) %>%
  ungroup() %>% 
  mutate(Palindromes = map_chr(.x = Palindromes, .f = ~ paste(str_to_sentence(.x), collapse = ", ")))