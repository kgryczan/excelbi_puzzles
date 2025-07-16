library(tidyverse)
library(readxl)

path = "Excel/200-299/268/268 Baconian Decrypter.xlsx"
input = read_excel(path, range = "A1:A7")
test  = read_excel(path, range = "B1:B7")

from_binary = function(x) {
  strtoi(x, base = 2)
}

result = input %>%
  mutate(text = str_split(`Encrypted Text`, "")) %>%
  unnest(text) %>%
  mutate(group = (row_number() - 1)  %/% 5  + 1, .by = `Encrypted Text`) %>%
  summarise(text = paste(text, collapse = ""), .by = c(`Encrypted Text`, group)) %>%
  mutate(text = str_replace_all(text, "a", "0")) %>%
  mutate(text = str_replace_all(text, "b", "1")) %>%
  mutate(text = map_chr(text, from_binary)) %>%
  mutate(text = as.numeric(text) + 1) %>%
  mutate(letter = letters[text]) %>%
  summarise(`Answer Expected` = paste(letter, collapse = "") %>% str_to_title(), .by = `Encrypted Text`)

all.equal(result$`Answer Expected`, test$`Answer Expected`) 
#> [1] TRUE