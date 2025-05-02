library(tidyverse)
library(readxl)

path = "Excel/178 Route Cipher.xlsx"
input = read_excel(path, range = "A1:B7")
test  = read_excel(path, range = "C1:C7")

encrypt = function(string, n) {
  string = gsub(" ", "", string)
  chars = str_split(string, "")[[1]]
  nrow = ceiling(length(chars)/n)
  ncol = n
  chars = c(chars, rep("", nrow*ncol - length(chars)))
  matrix = matrix(chars, nrow = nrow, ncol = ncol, byrow = TRUE) 
  encrypted = paste0(matrix, collapse = "")
  
  return(encrypted)
}

result = input %>%
  mutate(`Answer Expected` = map2_chr(String, n, encrypt))

all.equal(result$`Answer Expected`, test$`Answer Expected`)
#> [1] TRUE