library(tidyverse)
library(readxl)

input = read_excel("Excel/367 Extract the Word Starting at an Index.xlsx", range = "A1:B10")
test  = read_excel("Excel/367 Extract the Word Starting at an Index.xlsx", range = "C1:C10")

extract_word_by_index = function(sentence, index) {
  word_pos = str_locate_all(sentence, "\\w+") %>% as.data.frame()
  word = word_pos %>% filter(start == index) 
  
  if (nrow(word) == 0) {
    word = NA_character_
  } else {
    word = sentence %>% str_sub(start = word$start, end = word$end)
  }
  
  return(word)
}

result = input %>% 
  mutate(`Answer Expected` = map2_chr(Sentence, Index, extract_word_by_index))

identical(result$`Answer Expected`, test$`Answer Expected`)
# [1] FALSE
# Mistake in the puzzle 

input %>% bind_cols(test) %>% bind_cols(result$`Answer Expected`)


