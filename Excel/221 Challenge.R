library(tidyverse)
library(readxl)

path = "Excel/221 Consecutive 1s Counts.xlsx"
input = read_excel(path, range = "A1:A9")
test  = read_excel(path, range = "B1:B9") %>% 
  mutate(across(everything(), ~ replace_na(.x, ""))) 

result = input %>%
  mutate(String = str_remove_all(String, ", ")) %>%
  mutate(s2 = str_extract_all(String, "[1]{2,}")) %>%
  mutate(s2 = map(s2, ~ str_length(.x))) %>%
  mutate(s2 = map(s2, ~ paste(.x, collapse = ", "))) 

all.equal(result$s2, test$`Answer Expected`, check.attributes = FALSE) 
# [1] TRUE