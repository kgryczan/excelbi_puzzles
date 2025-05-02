library(tidyverse)
library(readxl)

path = "Excel/004 Find Words All Capitals.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10") 
test[is.na(test)] = ""

result = input %>%
  rowwise() %>%
  mutate(`Answer Expected` = str_extract_all(Words,"\\b[A-Z]+\\b")) %>%
  ungroup() %>%
  mutate(`Answer Expected` = map_chr(`Answer Expected`, ~paste(.x, collapse = " ")))
  

all.equal(result$`Answer Expected`, test$`Answer Expected`, check.attributes = FALSE)
#> [1] TRUE