library(tidyverse)
library(readxl)

path = "Excel/026 Caesars Cipher_2.xlsx"
input = read_excel(path, range = "A1:B10")
test  = read_excel(path, range = "C1:C10")

result = input %>%
  mutate(nr = row_number()) %>%
  separate_rows(Text, sep = "") %>%
  filter(Text != "") %>%
  mutate(position = case_when(
    Text %in% letters ~ match(Text, letters),
    Text %in% LETTERS ~ match(Text, LETTERS),
    TRUE ~ NA_integer_
  )) %>%
  mutate(shifted_position = if_else(is.na(position), NA_integer_, (position + (Shift %% 26)) %% 26)) %>%
  mutate(shifted_position = if_else(shifted_position == 0, 26, shifted_position)) %>%
  mutate(Shifted = case_when(
    Text %in% as.vector(letters) ~ letters[shifted_position],
    Text %in% as.vector(LETTERS) ~ LETTERS[shifted_position],
    TRUE ~ Text
  )) %>%
  summarise(Text = paste(Shifted, collapse = ""), .by = nr)

identical(result$Text, test$`Expected Answer`)
# [1] TRUE