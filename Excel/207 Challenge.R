library(tidyverse)
library(readxl)

path = "Excel/207 Date Shift Cipher.xlsx"
input = read_excel(path, range = "A1:B7")
test  = read_excel(path, range = "C1:C7")

encode <- function(message, key) {
  key_rep <- str_c(rep(key, length.out = ceiling(nchar(message) / nchar(key))), collapse = "")
  key_adj <- str_sub(key_rep, 1, nchar(message))
  
  df <- tibble(
    letter = str_split(message, "", simplify = TRUE)[1, ],
    digit  = as.numeric(str_split(key_adj, "", simplify = TRUE)[1, ])
  )

  encoded <- map2_chr(df$letter, df$digit, function(letter, shift) {
    if (!letter %in% letters) return(letter)
    idx <- match(letter, letters)
    new_idx <- (idx + shift - 1) %% 26 + 1
    letters[new_idx]
  })
  
  str_c(encoded, collapse = "")
}

result = input %>%
  mutate(`Answer Expected` = map2_chr(Message, Key, encode)) %>%
  select(-c(Message, Key))

all.equal(result, test)
#> [1] TRUE