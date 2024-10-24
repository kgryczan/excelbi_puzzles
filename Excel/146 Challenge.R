library(tidyverse)
library(readxl)

path = "Excel/146 Pangram.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B6")

is_pangram = function(sentence) {
  sentence = str_to_lower(sentence) %>%
    str_replace_all("[^a-z]", "") %>%
    str_split("") %>%
    unlist() %>%
    str_sort() %>%
    unique()
  
  all(sentence == letters) && length(sentence) == 26
}

result = input %>%
  mutate(is_pangram = map_lgl(Sentences, is_pangram)) %>%
  filter(is_pangram)

all.equal(result$Sentences, test$`Expected Answer`, check.attributes = FALSE)
# [1] TRUE