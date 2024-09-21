library(tidyverse)
library(readxl)

path = "Excel/082 Reverse Words.xlsx"
input = read_excel(path, range = "A1:A5")
test  = read_excel(path, range = "B1:B5")

reverse_words = function(text) {
  words = str_split(text, ", ")[[1]]
  words = rev(words)
  text = paste(words, collapse = ", ")
  return(text)
}

result = input %>%
  mutate(`Answer Expected` = map_chr(Words, ~ reverse_words(.x))) 

identical(result$`Answer Expected`, test$`Answer Expected`)
# [1] TRUE