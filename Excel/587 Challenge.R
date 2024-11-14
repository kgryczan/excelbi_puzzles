library(tidyverse)
library(readxl)
library(purrr)

path = "Excel/587 Repeat Vowels Order of Occurrence.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10")

process_string <- function(string) {
  tibble(char = str_split(string, "")[[1]]) %>%
    mutate(is_vowel = char %in% c("a", "e", "i", "o", "u"),
           count = cumsum(is_vowel) * is_vowel + (!is_vowel)) %>%
    mutate(char2 = str_dup(char, count)) %>%
    summarise(result = str_c(char2, collapse = "")) %>%
    pull(result)
}

result = input %>%
  mutate(`Answer Expected` = map_chr(Strings, process_string))

all.equal(result$`Answer Expected`, test$`Answer Expected`)
#> [1] TRUE