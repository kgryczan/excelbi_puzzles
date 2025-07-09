library(tidyverse)
library(readxl)
library(stringi)

path = "Excel/200-299/246/246 Order the Words.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10") %>%
  arrange(`Answer Expected`)

result = input %>%
  mutate(words = str_split(string = Sentences, pattern = " ")) %>%
  unnest(words) %>%
  mutate(number = str_extract(string = words, pattern = "\\d+")) %>%
  arrange(number, words) %>%
  summarise(Sentences2 = str_c(words, collapse = " "), .by = Sentences) %>%
  select(Sentences2) %>%
  arrange(Sentences2)

all.equal(result$Sentences2, test$`Answer Expected`)
# > [1] TRUE
