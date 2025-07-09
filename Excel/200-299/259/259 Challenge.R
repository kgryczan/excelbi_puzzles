library(tidyverse)
library(readxl)

path = "Excel/200-299/259/259 Repeating Alphabets to be replaced by Brackets.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10")

result = input %>%
  mutate(char = str_split(Words, "")) %>%
  unnest(char) %>%
  mutate(char = str_to_lower(char)) %>%
  mutate(n = n(), 
         .by = c(Words, char)) %>%
  mutate(n = ifelse(n > 1, ")", "(")) %>%
  summarise(n = paste0(n, collapse = ""), 
            .by = Words) 

all.equal(result$n, test$`Answer Expected`, check.attributes = FALSE) 
# > [1] TRUE