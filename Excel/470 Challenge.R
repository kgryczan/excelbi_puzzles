library(tidyverse)
library(readxl)
library(gtools)

input = read_excel("Excel/469 Next Greater Number with Same Digits.xlsx", range = "A1:A10")
test  = read_excel("Excel/469 Next Greater Number with Same Digits.xlsx", range = "B1:B10")

find_greater_from_same_digits = function(number) {
  number = as.character(number)
  n = nchar(number)
  number_splitted = as.numeric(unlist(strsplit(number, "")))

  i = n - 1
  while (i > 0) {
    if (number_splitted[i] < number_splitted[i + 1]) {
      break
    }
    i = i - 1
  }
  if (i == 0) {
    return("No such number")
  }
  j = n
  while (j > i) {
    if (number_splitted[j] > number_splitted[i]) {
      break
    }
    j = j - 1
  }
  number_splitted[c(i, j)] = number_splitted[c(j, i)]
  number_splitted = c(number_splitted[1:i], rev(number_splitted[(i + 1):n]))
  return(paste(number_splitted, collapse = ""))
}

result = input %>%
  mutate(`Answer Expected` = map_chr(Number, find_greater_from_same_digits)) 

identical(result$`Answer Expected`, test$`Answer Expected`)
# [1] TRUE
