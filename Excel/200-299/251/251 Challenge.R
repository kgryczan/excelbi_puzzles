library(tidyverse)
library(readxl)

path = "Excel/200-299/251/251 Cyclic Type of Number.xlsx"
input = read_excel(path, range = "A1:A11")
test  = read_excel(path, range = "B1:B7")

result = input %>%
  mutate(digit_cnt = str_count(as.character(Numbers)),
         factor_list = map(digit_cnt, ~ seq(2, .x)),
         digit_list = str_split(as.character(Numbers), "") %>%
           map(~ sort(unique(as.numeric(.x)))) %>%
           map_chr(~ paste(.x, collapse = ""))) %>%
  unnest(factor_list) %>%
  mutate(mult = Numbers * factor_list,
         mult_digits = str_split(as.character(mult), "") %>%
           map(~ sort(unique(as.numeric(.x)))) %>%
           map_chr(~ paste(.x, collapse = ""))) %>%
  filter(digit_list == mult_digits) %>%
  select(Numbers) %>%
  distinct()

all.equal(result$Numbers, test$`Expected Answer`, check.attributes = FALSE) 
# > [1] TRUE