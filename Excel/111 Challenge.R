library(tidyverse)
library(readxl)
library(english)

path = "Excel/111 Number of English Alphabets.xlsx"
input = read_excel(path, range = "A1:B6")
test  = read_excel(path, range = "C1:C6")

result = input %>%
  mutate(seq = map2(From, To, seq)) %>%
  unnest(seq) %>%
  mutate(digits = strsplit(as.character(seq), "")) %>%
  unnest(digits) %>%
  mutate(digits = as.numeric(digits)) %>%
  mutate(Answer = english(digits) %>% as.character() %>% nchar()) %>%
  summarise(Answer = sum(Answer), .by = c(From, To))

all.equal(result$Answer, test$Answer)
#> [1] TRUE