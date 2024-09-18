library(tidyverse)
library(readxl)

path = "Excel/054 US Presidents.xlsx"
input = read_excel(path, range = "A1:A47")
test  = read_excel(path, range = "B1:B11")

result = input %>%
  filter(str_detect(`US Presidents`, "B"))

identical(result$`US Presidents`, test$`Answer Expected`)
# [1] TRUE