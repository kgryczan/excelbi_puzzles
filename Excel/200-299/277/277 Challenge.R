library(tidyverse)
library(readxl)

input = read_excel("Order the Words_2.xlsx")

result = input %>%
  mutate(words = str_split(Sentences, " "), 
         cleaned_words = map(words, ~ str_replace_all(.x, "\\d+","")),
         numbers = map(words, ~ as.numeric(str_extract(.x, "\\d+"))),
         sorted_words = map2(cleaned_words, numbers, ~ .x[order(.y)]),
         sorted_sentence = map_chr(sorted_words, ~ paste(.x, collapse = " "))) %>%
  select(Sentences,`Answer Expected`,sorted_sentence) %>%
  mutate(is_answer_correct = `Answer Expected` == sorted_sentence)

print(result)