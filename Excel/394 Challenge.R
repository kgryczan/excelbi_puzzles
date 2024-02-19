library(tidyverse)
library(readxl)

test = read_excel("Excel/394 - First 15 Super Palindrome Numbers.xlsx", range = "A1:A16")

is_palindrome = function(x) {
  x = as.character(x)
  x == str_c(rev(str_split(x, "")[[1]]), collapse = "")
}

result = tibble(palindrome = keep(10:1e5, is_palindrome)) %>%
  mutate(square = palindrome^2,
         is_palindrome = map_lgl(square, is_palindrome)) %>%
  filter(is_palindrome) %>%
  slice(1:15) %>%
  select(square)

