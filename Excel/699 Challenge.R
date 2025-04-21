library(tidyverse)
library(readxl)
library(stringi)

path = "Excel/699 Palindrome after one character removal.xlsx"
input = read_excel(path, range = "A1:A10")
test = read_excel(path, range = "B1:B10") %>%
  replace_na(list(`Answer Expected` = ""))

remove_each_char <- function(word) {
  map_chr(
    seq_len(nchar(word)),
    \(i) paste0(substr(word, 1, i - 1), substr(word, i + 1, nchar(word)))
  )
}
is_palindrome = function(word) {
  word == stri_reverse(word)
}

result = input %>%
  mutate(words = map(Words, remove_each_char)) %>%
  unnest_longer(words) %>%
  mutate(is_palindrome = map_lgl(words, is_palindrome)) %>%
  filter(is_palindrome) %>%
  select(-is_palindrome)

result2 = input %>%
  left_join(result, by = c("Words" = "Words")) %>%
  replace_na(list(words = ""))
