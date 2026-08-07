library(tidyverse)
library(readxl)

path <- "C:/Users/kgryc/Documents/excelbi_puzzles/Excel/1000-1099/1037/1037 Anagram Pairing.xlsx"
input <- read_excel(path, range = "A1:A21")
test <- read_excel(path, range = "C1:C6")

result <- input %>%
  transmute(word = str_to_lower(str_remove_all(Data, "[^A-Za-z]"))) %>%
  mutate(
    key = map_chr(word, ~ str_c(sort(str_split_1(.x, "")), collapse = ""))
  ) %>%
  distinct(word, key) %>%
  group_by(key) %>%
  summarise(words = list(sort(word)), .groups = "drop") %>%
  filter(map_int(words, length) > 1) %>%
  arrange(map_chr(words, first)) %>%
  transmute(`Answer Expected` = map_chr(words, ~ str_c(.x, collapse = " | ")))

print(all.equal(result, test))
# Incorrect position 1 in list.
