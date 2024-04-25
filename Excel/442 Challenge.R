library(tidyverse)
library(readxl)

input = read_excel("Excel/442 Columnar Transposition Cipher.xlsx", range = "A1:B10")
test  = read_excel("Excel/442 Columnar Transposition Cipher.xlsx", range = "C1:C10")

encode = function(text, keyword){
  keyword = strsplit(keyword, "")[[1]] %>%
    rank(ties.method = "first")
  l_key = length(keyword)
  
  text = str_extract_all(text, "[a-z]")[[1]]
  text_filled = c(text, rep("", l_key - length(text) %% l_key))
  
  matrix_text = matrix(text_filled, ncol = l_key, byrow = TRUE)
  matrix_text = matrix_text[, order(keyword)] %>% t()
  matrix_text = matrix_text %>%
    apply(1, paste, collapse = "") %>%
    paste(collapse = " ")
  
  return(matrix_text)
}

result = input %>%
  mutate(`Answer Expected` = map2_chr(`Plain Text`, Keyword, encode))

identical(result$`Answer Expected`, test$`Answer Expected`)
#> [1] TRUE