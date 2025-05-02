library(tidyverse)
library(readxl)

input = read_excel("Excel/360 Reverse alphabets only.xlsx", range = "A1:A13")
test  = read_excel("Excel/360 Reverse alphabets only.xlsx", range = "B1:B13")

reverse_alpha = function(word) {
  chars = strsplit(word, "")[[1]]
  pos = which(chars %in% c(letters, LETTERS))
  alphas = chars[pos]
  rev_alphas = rev(alphas)
  chars[pos] = rev_alphas
  processed = paste(chars, collapse = "")
  return(processed)
}

output = input %>%
  mutate(`Answer Expected` = map_chr(Strings, reverse_alpha))

identical(output$`Answer Expected`, test$`Answer Expected`)
# [1] TRUE
