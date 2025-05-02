library(tidyverse)
library(readxl)

path = "Excel/187 Second Word Anagram.xlsx"
input = read_excel(path, range = "A1:A9")
test  = read_excel(path, range = "B1:B5")

result = input %>%
  separate(col = "Words", into = c("Word1", "Word2"), sep = " ", remove = F) %>%
  mutate(across(c(Word1, Word2), tolower)) %>%
  mutate(across(c(Word1, Word2), strsplit, "")) %>%
  mutate(across(c(Word1, Word2), ~map(., sort))) %>%
  mutate(Anagram = map2_lgl(Word1, Word2, ~identical(.x, .y))) %>%
  filter(Anagram) %>%
  select(Words)

all.equal(result$Words, test$`Answer Expected`)                  
#> [1] TRUE