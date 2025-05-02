library(tidyverse)
library(readxl)

path = "Excel/050 Anagram.xlsx"
input = read_excel(path, range = "A1:B10")
test  = read_excel(path, range = "C2:D7")

result = input %>%
  mutate(
    word1 = strsplit(Word1, ""),
    word2 = strsplit(Word2, ""),
    word1 = map_chr(word1, ~sort(tolower(.x[.x != " "])) %>% paste(collapse = "")),
    word2 = map_chr(word2, ~sort(tolower(.x[.x != " "])) %>% paste(collapse = ""))) %>%
  filter(word1 == word2) %>%
  select(Word1, Word2)

identical(result, test)
# [1] TRUE