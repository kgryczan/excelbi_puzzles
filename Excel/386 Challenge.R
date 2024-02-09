library(tidyverse)
library(readxl)

input = read_excel("Excel/386 Extract Numbers in Parentheses.xlsx", range = "A1:A10")
test  = read_excel("Excel/386 Extract Numbers in Parentheses.xlsx", range = "B1:B10")

extract = function(x) {
  x = str_extract_all(x, "\\((\\d+)\\)") %>%
    unlist() %>%
    str_remove_all("\\D") %>%
    str_c(collapse = ", ")
  if (x == "") x = NA_character_
  return(x)
}

result = input %>%
  rowwise() %>%
  mutate(result = map_chr(String, extract))

identical(result$result, test$`Answer Expected`)
# [1] TRUE
