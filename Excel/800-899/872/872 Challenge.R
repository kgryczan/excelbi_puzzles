library(tidyverse)
library(readxl)

path <- "Excel/800-899/872/872 Make Alternate Vowel Uppercase.xlsx"
input <- read_excel(path, range = "A1:A50")
test <- read_excel(path, range = "B1:B50")

result = input %>%
  mutate(rn = row_number()) %>%
  mutate(chars = str_split(Data, "")) %>%
  unnest_longer(chars) %>%
  mutate(
    is_vowel = chars %in% c("a", "e", "i", "o", "u", "A", "E", "I", "O", "U")
  ) %>%
  group_by(rn) %>%
  mutate(vowel_count = cumsum(is_vowel)) %>%
  mutate(
    chars = if_else(is_vowel & vowel_count %% 2 == 0, toupper(chars), chars)
  ) %>%
  summarise(Data = str_c(chars, collapse = ""))

all(result$Data == test$`Answer Expected`)
