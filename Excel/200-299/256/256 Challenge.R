library(tidyverse)
library(readxl)

path = "Excel/200-299/256/256 Index of Vowels.xlsx"
input = read_excel(path, range = "A1:A9")
test  = read_excel(path, range = "B1:B9") %>% na.omit()

input_vowels = input %>%
  mutate(chars = str_split(Words, "")) %>%
  unnest(chars) %>%
  mutate(index = row_number(), .by = Words) %>%
  filter(str_detect(chars, "[aeiou]")) %>%
  unite(`Answer Expected`, chars, index, sep = "-") %>%
  summarise(`Answer Expected` = paste(`Answer Expected`, collapse = ", "), .by = Words) 

all.equal(input_vowels$`Answer Expected`, test$`Answer Expected`)
# > TRUE