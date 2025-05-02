library(tidyverse)
library(readxl)

path = "Excel/633 Encryption by Printable Characters.xlsx"
input = read_excel(path, range = "A1:B10")

n_random_chars <- function(n) {
  random_chars = sample(32:132, n, replace = TRUE) %>%
    intToUtf8()
  return(random_chars)
}

encode_word = function(word, key) {
  word = strsplit(word, "")[[1]]
  key = strsplit(key, "")[[1]]
  l_word = length(word)
  l_key = length(key)
  
  key = if (l_word > l_key) rep(key, length.out = l_word + 1) else key[1:(l_word + 1)]
  
  df = data.frame(word = c(word, ""), key = key) %>%
    mutate(key_num = map_dbl(key, ~which(.x == letters)),
           random_chars = map_chr(key_num, ~n_random_chars(.x))) %>%
    unite("encoded", word, random_chars, sep = "", remove = F) %>%
    summarise(encoded = paste(encoded, collapse = "")) %>%
    pull(encoded)
  
  return(df)
}

result = input %>%
  mutate(Sample_answer = map2_chr(input$Words, input$key, ~encode_word(.x, .y)))
