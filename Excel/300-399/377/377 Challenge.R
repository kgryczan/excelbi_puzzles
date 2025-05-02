library(tidyverse)
library(readxl)

input = read_excel("Excel/377 Keyword Cipher.xlsx", range = "A1:B10")
test  = read_excel("Excel/377 Keyword Cipher.xlsx", range = "C1:C10")

prepare_keycode = function(keyword) {
  keyword = str_split(keyword, "")[[1]] %>%
    unique()
  alphabet = letters
  keycode = c(keyword, alphabet[!alphabet %in% keyword])  
  return(keycode)
}

encode = function(sentence, keyword) {
  keycode = prepare_keycode(keyword)
  code = set_names(keycode, letters)
  words = str_split(sentence, " ")[[1]]
  words = words %>%
    map(str_split, "") %>%
    map(function(x) {
      x = x %>%
        unlist() %>%
        code[.] %>%
        paste(., collapse = "")
      return(x)
    })
  sentence = paste(words, collapse = " ")
  return(sentence)
}

result = input %>%
  mutate(`Answer Expected` = map2_chr(`Plain Text`, Keyword, encode))

identical(result$`Answer Expected`, test$`Answer Expected`)
# [1] TRUE
