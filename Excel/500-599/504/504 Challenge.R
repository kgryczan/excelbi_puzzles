library(tidyverse)
library(readxl)

path = "Excel/504 US Presidents All First Chars Same.xlsx"
input = read_excel(path, range = "A1:A47")
test = read_excel(path, range = "B1:B5")

result = input %>%
  filter(map(`US Presidents`,  ~ length(str_extract_all(., "[A-Z]") %>% 
                                          unlist() %>% unique())) == 1)

identical(result$`US Presidents`, test$`Answer Expected`)
# [1] TRUE