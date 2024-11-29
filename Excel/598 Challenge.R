library(tidyverse)
library(readxl)

path = "Excel/598 Palindromic Step Harshad Numbers.xlsx"
test  = read_excel(path, range = "A1:A10")

is_palindromic = function(number) {
  as.character(number) == str_c(rev(str_split(as.character(number), "")[[1]]), collapse = "")
}

is_step = function(number) {
  digits = as.integer(str_split(as.character(number), "")[[1]])
  all(abs(diff(digits)) == 1)
}

is_harshad = function(number) {
  digits = as.integer(str_split(as.character(number), "")[[1]])
  number %% sum(digits) == 0
}

result = 10:10000000 %>% 
  keep(is_palindromic) %>% 
  keep(is_step) %>% 
  keep(is_harshad)

all.equal(result, test$`Answer Expected`)
# [1] TRUE