library(tidyverse)
library(readxl)

input = read_excel("Power Query/PQ_Challenge_164.xlsx", range = "A1:E7")
test  = read_excel("Power Query/PQ_Challenge_164.xlsx", range = "G1:J13")

result = input %>%
  pivot_longer(cols = -c(1), 
               names_to = c(".value", "suffix"), 
               names_pattern = "(\\D+)(\\d+)") %>%
  mutate(Type = str_extract_all(Number, "[A-Z]+") %>% map_chr(~paste(., collapse = "")),
         Code = str_extract_all(Number, "\\d+") %>% map_chr(~paste(., collapse = ""))) %>%
  select(Group, Type, Code, Value) 

identical(result, test)
# [1] TRUE
