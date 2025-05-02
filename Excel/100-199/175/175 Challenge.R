library(tidyverse)
library(readxl)

path = "Excel/175 Common Words in Sentences.xlsx"
input = read_excel(path, range = "A1:B9")
test  = read_excel(path, range = "C1:C9") %>% replace_na(list(`Answer Expected` = ""))

result = input %>%
  mutate(Sentence1 = str_split(Sentence1, " "),
         Sentence2 = str_split(Sentence2, " ")) %>%
  mutate(`Answer Expected` = map2(Sentence1, Sentence2, ~intersect(.x, .y))) %>%
  mutate(`Answer Expected` = map_chr(`Answer Expected`, ~paste(sort(.x), collapse = ", "))) %>%
  select(-Sentence1, -Sentence2)

all.equal(result, test)
#> [1] TRUE