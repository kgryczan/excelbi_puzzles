library(tidyverse)
library(readxl)

input = read_excel("Excel/417 Split Alphabets and Numbers.xlsx", range = "A1:A10")
test  = read_excel("Excel/417 Split Alphabets and Numbers.xlsx", range = "B1:B10")

pattern = ("[A-Za-z]+|[0-9]+")

result = input %>%
  mutate(splitted = map_chr(Data, ~str_extract_all(., pattern) %>% unlist() %>% 
                          str_c(collapse = ", "))) 

identical(result$splitted, test$`Expected Answer`)
# [1] TRUE