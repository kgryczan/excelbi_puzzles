library(tidyverse)
library(readxl)

path = "Excel/629 Invert Sign.xlsx"
input = read_excel(path, range = "A1:A10", col_names = "Words")
test  = read_excel(path, range = "B1:B10")

result = input %>%
  mutate(`Answer Expected` = str_replace_all(Words, "([+-])(?=\\d)", function(m) ifelse(m == "+", "-", "+")))

all.equal(result$`Answer Expected`, test$`Answer Expected`)
#> [1] TRUE