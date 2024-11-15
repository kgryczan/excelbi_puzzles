library(tidyverse)
library(readxl)
library(stringi)

path = "Excel/161 Reverse Words_2.xlsx"
input = read_excel(path, range = "A1:B10")
test  = read_excel(path, range = "C1:C10")

result = input %>%
  mutate(ID = row_number(), Word = str_split(Sentence, " ")) %>%
  unnest(Word) %>%
  mutate(len = str_length(Word)) %>%
  mutate(Word = ifelse(len > Number, stri_reverse(Word), Word)) %>%
  summarise(Sentence = paste(Word, collapse = " "), .by = ID)

all.equal(result$Sentence, test$`Answer Expected`)
# [1] TRUE