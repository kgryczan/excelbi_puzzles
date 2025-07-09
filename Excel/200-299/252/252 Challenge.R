library(tidyverse)
library(readxl)

path = "Excel/200-299/252/252 Expanded Form of Numbers.xlsx"
input = read_excel(path, range = "A1:A9")
test  = read_excel(path, range = "B1:B9")

expand_number = function(n) {
  digits = strsplit(as.character(n), "")[[1]] |> as.integer()
  powers = rev(seq_along(digits) - 1)
  parts = digits * 10^powers
  parts[parts != 0] |> paste(collapse = "+")
}

result = input %>%
  mutate(Expanded = map_chr(Number, expand_number)) %>%
  select(-Number)

all.equal(result$Expanded, test$`Answer Expected`, check.attributes = FALSE)
# > [1] TRUE