library(tidyverse)
library(readxl)

path = "Excel/034 Extract Last Group of Numbers.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10")

result = input %>%
  mutate(a = str_extract_all(String, "\\d+")) %>%
  mutate(a = map_chr(a, ~if(length(.) > 0) tail(., 1) else NA)) 

identical(result$a, test$`Answer Expected`)
# [1] TRUE