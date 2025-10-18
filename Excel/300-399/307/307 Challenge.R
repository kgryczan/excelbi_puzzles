library(tidyverse)
library(readxl)
library(stringi)

input = read_excel("Palindromic Phrase.xlsx", range = "A1:A10")
test = read_excel("Palindromic Phrase.xlsx", range = "B1:B6")

result = input %>%
  mutate(phrase = Phrase %>% 
           str_remove_all("[[:punct:]]") %>%
           str_remove_all(" ") %>%
           str_to_lower(),
         is_palindromic = phrase == stri_reverse(phrase)) %>%
  filter(is_palindromic) %>%
  select(`Answer Expected` = Phrase)

identical(test, result)
#> [1] TRUE