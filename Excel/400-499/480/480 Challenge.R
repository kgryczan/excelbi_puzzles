library(tidyverse)
library(readxl)

path = "Excel/480 Caesar's Cipher_Decrypter.xlsx"
input = read_excel(path, range = "A1:B10")
test  = read_excel(path, range = "C1:C10")

decrypt_caesar <- function(encrypted_text, shift) {
  shift_char <- function(char, shift_value) {
    if (char %in% letters) {
      base <- 97
      char_val <- utf8ToInt(char) - base
      shifted_val <- (char_val - shift_value) %% 26
      intToUtf8(shifted_val + base)
    } else if (char %in% LETTERS) {
      base <- 65
      char_val <- utf8ToInt(char) - base
      shifted_val <- (char_val - shift_value) %% 26
      intToUtf8(shifted_val + base)
    } else {
      char
    }
  }
  decrypt_char <- Vectorize(shift_char, "char")
  decrypted_text <- map2_chr(str_split(encrypted_text, "")[[1]], 0:(nchar(encrypted_text) - 1), 
                             ~ decrypt_char(.x, shift + .y))
  paste0(decrypted_text, collapse = "")
}

result = input %>%
  mutate(`Answer Expected` = map2_chr(`Encrypted Text`, Shift, decrypt_caesar)) %>%
  select(`Answer Expected`)

identical(result, test)
# [1] TRUE