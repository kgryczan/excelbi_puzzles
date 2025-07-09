library(tidyverse)
library(readxl)

path = "Excel/700-799/756/756 Replace Vowels.xlsx"
input = read_excel(path, range = "A1:A9")
test  = read_excel(path, range = "B1:B9")

result = input %>%
  mutate(char = str_split(Words, "")) %>%
  unnest(char) %>%
  mutate(counter = ifelse(char %in% c("a", "e", "i", "o", "u"), 
                          cumsum(char %in% c("a", "e", "i", "o", "u")), 
                          NA_integer_), .by = Words) %>%
  unite("Word_c", char, counter, sep = "", remove = T, na.rm = T) %>%
  summarise(`Answer Expected` = paste(Word_c, collapse = ""), .by = Words)

all.equal(result$`Answer Expected`, test$`Answer Expected`, check.attributes = FALSE) 
# > [1] TRUE