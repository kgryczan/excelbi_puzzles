library(tidyverse)
library(readxl)

input = read_excel("Excel/363 Increment last number by 1.xlsx", range = "A1:A10")
test  = read_excel("Excel/363 Increment last number by 1.xlsx", range = "B1:B10")

add_one = function(x) {
  original_length <- nchar(x) 
  incremented_number <- as.numeric(x) + 1
  str_pad(incremented_number, original_length, pad = "0")
}

process_word = function(word) {
  if (str_detect(word, "\\d+$")) {  
    parts = str_match(word, "(.*?)(\\d+)$")  
    return(paste0(parts[2], add_one(parts[3])))  
  } else {
    return(word)  
  }
}

process_text = function(text) {
  words = unlist(str_split(text, " "))  
  processed_words = map_chr(words, process_word)  
  text_concat = str_c(processed_words, collapse = " ")
  return(text_concat)  
}

result = input %>%
  mutate(`Answer Expected` = map_chr(Sentences, process_text))

identical(result$`Answer Expected`, test$`Answer Expected`)
#> [1] TRUE

