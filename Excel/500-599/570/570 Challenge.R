library(tidyverse)
library(readxl)

path = "Excel/570 Position Swapping.xlsx"
input = read_excel(path, range = "A1:B10")
test  = read_excel(path, range = "C1:C10")

swap_string = function(string, numbers) {
  numbers = as.numeric(str_split(numbers, ",\\s*")[[1]])
  str_vec = str_split(string, "", simplify = TRUE)
  for (i in seq(1, length(numbers), by = 2)) {
    str_vec[c(numbers[i], numbers[i + 1])] = str_vec[c(numbers[i + 1], numbers[i])]
  }
  str_c(str_vec, collapse = "")
}

result = input %>%
  mutate(Swapped = map2_chr(String, Numbers, swap_string))

all.equal(result$Swapped, test$`Answer Expected`)
# [1] TRUE