library(tidyverse)
library(readxl)

path = "Excel/492 Date Shift Cipher Decrypter.xlsx"

input = read_xlsx(path, range = "A1:B7")
test  = read_xlsx(path, range = "C1:C7")

decrypt_date_cipher <- function(text, date) {
  key <- str_sub(str_c(rep(date, ceiling(nchar(text) / nchar(date))), collapse = ""), 1, nchar(text))
  text_nums <- utf8ToInt(str_to_lower(text)) - utf8ToInt("a")
  key_nums <- key %>%
    str_split("") %>%
    flatten_chr() %>%
    as.integer()
  decrypted_nums <- map2_int(text_nums, key_nums, ~ (.x - .y + 26) %% 26 + utf8ToInt("a"))
  decrypted_text <- intToUtf8(decrypted_nums)
  return(decrypted_text)
}

output = input  %>%
  mutate(`Answer Expected` = map2_chr(Message, Key, decrypt_date_cipher))

identical(output$`Answer Expected`, test$`Answer Expected`)         
#> [1] TRUE 