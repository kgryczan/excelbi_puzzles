library(tidyverse)
library(readxl)

path = "Excel/144 Acronym Matching.xlsx"
input = read_excel(path, range = "A1:A9")
test  = read_excel(path, range = "C2:D11")

result = input %>%
  mutate(acronym  = str_extract_all(Words, "[A-Z]") %>% map_chr(~paste(., collapse = ""))) %>%
  left_join(test, by = c("acronym" = "Acronyms")) %>%
  mutate(match = Words.x == Words.y)

# True