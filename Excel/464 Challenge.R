library(tidyverse)
library(readxl)
library(stringi)
library(R.utils)

test = read_excel('Excel/464 Palindromic Evil Numbers.xlsx', range = "A1:A1001")

is_palindromic = function(x) {
  x_str <- as.character(x)
  x_str == stri_reverse(x_str)
}

is_evil = function(x) {
  str_count(intToBin(x),"1") %% 2 == 0
}

range = tibble(numbers = 1:1000000) %>%
  mutate(palindromic = is_palindromic(numbers),
         evil = is_evil(numbers)) %>%
  filter(palindromic & evil) %>%
  filter(numbers >= 10) %>%
  head(1000)

all.equal(range$numbers, test$`Answer Expected`)
# [1] TRUE
