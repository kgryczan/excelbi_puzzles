library(tidyverse)
library(readxl)

path = "Excel/163 Replace Duplicate Character.xlsx"
input = read_excel(path, range = "A1:A11")
test  = read_excel(path, range = "B1:B11")

mask_word = function(word) {
  word_split = strsplit(str_to_lower(word), "")[[1]] %>%
    tibble(word = .) %>%
    mutate(rn = row_number())
  letter_count = table(word_split$word) %>% as.data.frame() 
  words = word_split %>%
    left_join(letter_count, by = c("word" = "Var1")) %>%
    mutate(mask = if_else(Freq > 1, "*", "?")) %>%
    pull(mask) %>%
    paste0(collapse = "")
  
  return(words)
}

result = input %>%
  mutate(masked = map_chr(Words, mask_word)) 

all.equal(result$masked, test$`Expected Answer`)
# [1] TRUE