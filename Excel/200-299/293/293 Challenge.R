library(tidyverse)
library(readxl)

input = read_excel("Alphabets in Sequence.xlsx", range = "A1:A10")
test = read_excel("Alphabets in Sequence.xlsx", range = "B1:B5")

is_alphabetical = function(word) {
  vector = str_split(word, pattern = "")[[1]]
  ordered_vector = sort(vector)
  check = identical(vector, ordered_vector)
  return(check)
}

result = input %>%
  mutate(check = map(Words, is_alphabetical)) %>%
  filter(check == T) %>%
  select(`Answer Expected` = Words)

identical(test, result)