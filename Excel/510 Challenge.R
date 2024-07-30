library(tidyverse)
library(readxl)

path = "Excel/510 Find Upper, Lower, Numbers & Special Chars Count.xlsx"
input = read_excel(path, range = "A2:A12")
test  = read_excel(path, range = "B2:E12")

result = input %>% 
  mutate(
    Data = ifelse(is.na(Data), "", Data),
    `Upper Case` = str_count(Data, "[A-Z]"),
    `Lower Case` = str_count(Data, "[a-z]"),
    Numbers = str_count(Data, "[0-9]"),
    `Special Chars` = str_count(Data, "[^A-Za-z0-9]")
  ) %>%
  select(-Data) %>%
  mutate(across(everything(), as.numeric))

identical(test, result)
# [1] TRUE