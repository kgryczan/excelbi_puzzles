library(tidyverse)
library(readxl)

path = "Excel/800-899/829/829 Extract Numbers Multiply and Sum.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10")

result = input %>%
  mutate(numbers = str_extract_all(Strings, "\\d+")) %>%
  unnest(numbers) %>%
  mutate(odd = (row_number() - 1) %% 2, 
         pair =  (row_number() - 1) %/% 2,
         .by = Strings) %>%
  pivot_wider(names_from = odd, values_from = numbers) %>%
  mutate(across(c(`0`, `1`), ~as.numeric(replace_na(.x, "1")))) %>%
  mutate(multiply = `0` * `1`) %>%
  summarise(Sum = sum(multiply), .by = Strings) 

all.equal(result$Sum, test$`Answer Expected`, check.attributes = FALSE)
# [1] TRUE