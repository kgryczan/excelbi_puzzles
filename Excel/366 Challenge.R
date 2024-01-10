library(tidyverse)
library(readxl)

input = read_excel("Excel/366 Exchange Alphabets and Numbers.xlsx", range = "A1:A10")
test  = read_excel("Excel/366 Exchange Alphabets and Numbers.xlsx", range = "B1:B10")

zip_string = function(string) {
  letters = str_extract_all(string, "[a-zA-Z]")[[1]]
  digits = str_extract_all(string, "[0-9]")[[1]]
  
  vec_diff = abs(length(letters) - length(digits))
  if (vec_diff > 0) {
    if (length(letters) > length(digits)) {
      digits = c(digits, rep("", vec_diff))
    } else {
      letters = c(letters, rep("", vec_diff))
    }
  }
  result = map2_chr(letters, digits, function(x, y) paste0(x, y)) %>% paste0(collapse = "")

  return(result)
}

result = input %>%
  mutate(`Answer Expected` = map_chr(Words, zip_string)) %>%
  select(-Words)

identical(result, test)
# [1] TRUE
