library(tidyverse)
library(readxl)
library(stringi)

path = "Excel/200-299/244/244 Super Palindromes.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B6")

is_palindrome = function(x) {
  s = as.character(x)
  s == stri_reverse(s)
}

result = input %>%
  filter(
    is_palindrome(Number),
    sqrt(Number) == floor(sqrt(Number)),
    is_palindrome(sqrt(Number))
  ) %>%
  select(Number)

all.equal(result$Number, test$`Answer Expected`, check.attributes = FALSE)
# > [1] TRUE