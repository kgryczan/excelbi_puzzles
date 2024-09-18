library(tidyverse)
library(readxl)

path = "Excel/047 Palindrome.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B3")

is_palindrome = function(x) {
  x = tolower(x)
  x = gsub("[^a-z]", "", x)
  x == stringr::str_c(rev(strsplit(x, "")[[1]]), collapse = "")
}

result = input %>%
  mutate(is_palindrome = map_lgl(Words, is_palindrome),
         len = nchar(Words)) %>%
  filter(is_palindrome) %>%
  slice_max(len, n = 1) %>%
  select(Words)

identical(result$Words, test$`Answer Expected`)
# [1] TRUE