library(tidyverse)
library(readxl)

input = read_excel("Excel/700-799/742/742 Anagram Listing.xlsx", range = "A1:A40")
test  = read_excel("Excel/700-799/742/742 Anagram Listing.xlsx", range = "B1:B11")

result = input %>%
  mutate(key = str_split(Words, "") %>% map_chr(~ paste(sort(.x), collapse = ""))) %>%
  filter(n() > 1, .by = key) %>%
  summarise(`Answer Expected` = paste(sort(Words), collapse = ", "), .by = key) %>%
  arrange(`Answer Expected`) %>%
  select(`Answer Expected`)

all.equal(result, test, check.attributes = FALSE)
 