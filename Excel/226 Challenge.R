library(tidyverse)
library(readxl)

path = "Excel/226 Sort only numbers.xlsx"
input = read_excel(path, range = "A1:A8")
test = read_excel(path, range = "B1:B8")

result = input %>%
  mutate(rn = row_number()) %>%
  separate_rows(Strings, sep = ", ") %>%
  mutate(Strings2 = str_remove_all(Strings, "[^0-9A-Za-z]")) %>%
  mutate(is_alphabet = str_detect(Strings2, "[A-Za-z]")) %>%
  arrange(rn, is_alphabet) %>%
  group_by(rn, is_alphabet) %>%
  mutate(
    custom_rank = ifelse(
      is_alphabet,
      row_number(),
      rank(Strings2, ties.method = "first")
    )
  ) %>%
  ungroup() %>%
  arrange(rn, is_alphabet, custom_rank) %>%
  summarise(Strings = paste(Strings, collapse = ", "), .by = rn)

all.equal(result$Strings, test$`Expected Answer`)
# [1] TRUE
