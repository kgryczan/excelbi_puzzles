library(tidyverse)
library(readxl)

input = read_excel("Vowels Reverse.xlsx")

reverse_vowels = function(word) {
  vowels = c("a","e","i","o","u","A","E","I","O","U")
  
  splitted_word = str_split(word,"") %>% unlist()
  
  vowels_positions = which(splitted_word %in% vowels)
  rev_vowels_positions = rev(vowels_positions)
  
  splitted_word[vowels_positions] <- splitted_word[rev_vowels_positions]
  
  rev_word = paste(splitted_word, collapse ="")
  
  return(rev_word)
}

a = "lewactwo"

reverse_vowels(a)

result = input %>%
  mutate(my_answer = map_chr(Words,reverse_vowels),
         test = Answer == my_answer)