library(tidyverse)
library(readxl)
library(stringi)

path = "Excel/183 Tetradic Number.xlsx"
input = read_excel(path, range = "A1:A8")
test  = read_excel(path, range = "B1:B5")

is_palindrome = function(number) {
  return(number == stri_reverse(number))
}
is_tetradic = function(number) {
  digits = unique(str_split(number, "")[[1]])
  all(digits %in% c("1","8","0")) & is_palindrome(number)
}

result = input %>%
  mutate(is_tetradic = map_lgl(Numbers, is_tetradic)) %>%
  filter(is_tetradic) %>%
  select(Numbers)

all.equal(result$Numbers, test$`Answers Expected`, check.attributes = FALSE)
#> [1] TRUE