library(tidyverse)
library(readxl)

path = "Excel/129 Sort the String2.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10")

sort_string = function(string) {
  letters = gsub("[^a-zA-Z]", "", string)
  digits = gsub("[^0-9]", "", string)
  letters = strsplit(letters, "")[[1]]
  letters = sort(letters)
  digits = strsplit(digits, "")[[1]]
  digits = sort(digits)
  digits = paste(digits, collapse = "")
  string = paste(letters, collapse = "")
  string = paste(string, digits, sep = "")
  
  return(string)
}

result = input %>%
  mutate(`Answer Expected` = map_chr(String, sort_string))

all.equal(result$`Answer Expected`, test$`Answer Expected`)
# [1] TRUE