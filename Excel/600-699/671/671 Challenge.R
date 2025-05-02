library(tidyverse)
library(readxl)

path = "Excel/671 Word Pairs Having All Vowels.xlsx"
input = read_excel(path, range = "A2:A11")
test  = read_excel(path, range = "B2:C6")

extract_vowels = function(word) {
  paste(sort(unique(unlist(str_extract_all(word, "[aeiou]")))), collapse = "")
}

result = expand.grid(input$Words, input$Words, stringsAsFactors = F) %>%
  filter(nchar(Var1) < nchar(Var2)) %>%
  mutate(combined = paste(Var1, Var2, sep = "")) %>%
  filter(map_chr(combined, extract_vowels) == "aeiou") %>%
  select(Var1, Var2)

# the same pairs, but with different order.