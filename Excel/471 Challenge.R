library(tidyverse)
library(readxl)

input = read_excel("Excel/471 Keyword Cipher Decrypter.xlsx", range = "A1:B10")
test  = read_excel("Excel/471 Keyword Cipher Decrypter.xlsx", range = "C1:C10")

prepare_keycode = function(keyword) {
  keyword = str_split(keyword, "")[[1]] %>%
    unique()
  alphabet = letters
  keycode = c(keyword, alphabet[!alphabet %in% keyword])  
  return(keycode)
}

decode = function(sentence, keyword) {
  keycode = prepare_keycode(keyword)
  code = set_names(letters, keycode,)
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
  mutate(`Answer Expected` = map2_chr(`Encrypted Text`, Keyword, decode))

identical(result$`Answer Expected`, test$`Answer Expected`)
# [1] TRUE
