library(tidyverse)
library(readxl)

path = "Excel/800-899/837/837 Product and Sum of Digits are Same.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B6")

result = input %>%
  mutate(digits = str_remove_all(as.character(Numbers), "\\D"),
         dgt = str_split(digits, ""), 
         sum_digits = map_int(dgt, ~ sum(as.integer(.x))),
         product_digits = map_int(dgt, ~ prod(as.integer(.x)))) %>%
  filter(sum_digits == product_digits) %>%
  mutate(`Answer Expected` = as.integer(digits)) %>%
  select(`Answer Expected`) 

all.equal(result, test)
# [1] TRUE