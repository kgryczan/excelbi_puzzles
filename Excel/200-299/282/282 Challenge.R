library(tidyverse)
library(readxl)

input = read_excel("Anagram Words.xlsx") %>% select(1)

result1 = input %>%
  mutate(letters = map(.$Words, ~ list(sort(unlist(str_split(string = .x, pattern ="")))) )) 

result2 = result1 %>%
  group_by(letters) %>%
  count() %>%
  ungroup()

result = result1 %>%
  left_join(result2, by = c("letters")) %>%
  filter(n != 1) %>%
  group_by(letters) %>%
  summarise(anagrams = paste(Words, collapse = ", ")) %>%
  ungroup() %>%
  select(anagrams)