library(tidyverse)
library(readxl)
library(stringi)

path = "Excel/003 Reverse Number.xlsx"
input = read_excel(path, range = "A1:A6")
test  = read_excel(path, range = "B1:B6")

result = input %>%
  mutate(`Expected Answer` = as.numeric(stri_reverse(as.character(Number)))) 

identical(result$`Expected Answer`, test$`Expected Answer`)
# [1] TRUE