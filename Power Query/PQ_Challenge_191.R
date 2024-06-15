library(tidyverse)
library(readxl)
library(rebus)

path = "Power Query/PQ_Challenge_191.xlsx"
input = read_excel(path, range = "A1:A11")
test = read_excel(path, range = "A1:B11") 

pattern1 = "\\b[A-Z]+(?:[!@#$%^&*_+=]*[A-Z]*)*[!@#$%^&*_+=]*[0-9]+(?:[!@#$%^&*_+=]*[0-9]*)*\\b"
pattern2 = "\\b[0-9]+(?:[!@#$%^&*_+=]*[0-9]*)*[!@#$%^&*_+=]*[A-Z]+(?:[!@#$%^&*_+=]*[A-Z]*)*\\b"

order_chars = function(text) {
  text = str_replace_all(text, "[^[:alnum:]]", "")
  letters = str_extract_all(text, "[A-Z]")[[1]] %>% paste0(collapse = "")
  numbers = str_extract_all(text, "[0-9]")[[1]] %>% paste0(collapse = "")
  result = paste0(letters, "_", numbers)
  return(result)
}


result = input %>%
  mutate(pat1 = str_extract_all(Text, pattern1),
         pat2 = str_extract_all(Text, pattern2)) %>%
  mutate(ext = map2(pat1, pat2, ~c(.x, .y))) %>%
  select(-c(pat1, pat2)) %>%
  unnest(ext, keep_empty = T) %>%
  mutate(result = map_chr(ext, order_chars)) %>%
  group_by(Text) %>%
  summarise(`Answer Expected` = paste0(result, collapse = ", ")) %>%
  mutate(`Answer Expected` = if_else(`Answer Expected` == "NA_NA", NA_character_, `Answer Expected`))

res = left_join(test, result, by = c("Text" = "Text"))
