library(tidyverse)
library(readxl)

path = "Excel/019 Longest Words.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10")

result = input %>%
  mutate(sent_num = row_number()) %>%
  separate_rows(Sentence, sep = " ") %>%
  filter(str_length(Sentence) == max(str_length(Sentence)), .by = sent_num) %>%
  mutate(Sentence = str_to_title(Sentence)) %>%
  summarise(Sentence = str_c(Sentence, collapse = ", "), .by = sent_num) %>%
  select(-sent_num)

identical(result$Sentence, test$`Answer Expected`)
#> [1] TRUE