library(tidyverse)
library(readxl)

input = read_excel("Excel/393 Autokey Cipher.xlsx", range = "A1:B10")
test  = read_excel("Excel/393 Autokey Cipher.xlsx", range = "C1:C10")

recode = function(string, keyword) {
  
  alphabet = data.frame(letters = letters, value = 0:25)
  string_length = nchar(string)
  keyword_length = nchar(keyword)
  str_chars = str_split(string, "")[[1]]
  key_chars = str_split(keyword, "")[[1]]
  
  if (keyword_length > string_length) {
    full_key = key_chars[1:string_length]
  } else if (keyword_length < string_length) {
    nchars_to_fill = string_length - keyword_length  
    chars_to_fill = str_chars[1:nchars_to_fill]
    full_key = c(key_chars, chars_to_fill)
  } else {
    full_key = key_chars
  }
  
  code_table = data.frame(string = str_chars, key = full_key)

  result = code_table %>%
    left_join(alphabet, by = c("string" = "letters")) %>%
    left_join(alphabet, by = c("key" = "letters")) %>%
    mutate(value = value.x + value.y) %>%
    select(string, key, value) %>%
    mutate(value_mod = value %% 26) %>%
    left_join(alphabet, by = c("value_mod" = "value")) %>%
    pull(letters) %>%
    paste(collapse = "")
  
  return(result)
}

result = input %>%
  mutate(answer = map2_chr(`Plain Text`, `Keyword`, recode))

identical(result$answer, test$`Answer Expected`)
# [1] TRUE
