library(tidyverse)
library(readxl)

path = "Excel/147 Narcissistic Number.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B6")

is_narcistic = function(number) {
  number = as.character(number)
  n = nchar(number)
  sum(as.numeric(strsplit(number, "")[[1]])^n) == as.numeric(number)
}

result = input %>%
  mutate(is_narcistic = map_lgl(Number, is_narcistic)) %>%
  filter(is_narcistic)

all.equal(result$Number, test$`Answer Expected`)
#> [1] TRUE