library(tidyverse)
library(readxl)
library(stringi)

path = "513 Sort by Unit Digit.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10")

result = input %>%
  arrange(str_sub(Numbers, -1)) 

identical(result$Numbers, test$`Answer Expected`)
# TRUE