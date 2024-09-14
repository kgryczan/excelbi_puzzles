library(tidyverse)
library(readxl) 

path = "Excel/007 Count English Alphabets & Numbers.xlsx"
input = read_excel(path, range = "A1:A8")
test  = read_excel(path, range = "B1:B8")

result = input %>%
  mutate(`Answer Expected` = str_count(String, "[A-Za-z0-9]")) %>%
  replace_na(list(`Answer Expected` = 0)) 
                                                                                                                      
all.equal(result$`Answer Expected`, test$`Expected Answers`)
#> [1] TRUE
          