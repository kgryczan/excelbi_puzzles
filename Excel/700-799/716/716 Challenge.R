library(tidyverse)
library(readxl)

path = "Excel/700-799/716/716 Key Cipher.xlsx"
input = read_excel(path, range = "A1:B10")
test = read_excel(path, range = "C1:C10")

encrypt = function(word, key) {
  chars = utf8ToInt(word)
  km = str_split(key, "", simplify = TRUE) %>% as.integer()
  kr = rep(km, length.out = length(chars))
  intToUtf8(chars + kr)
}

result = input %>%
  mutate(encrypted = map2_chr(Words, Key, encrypt))

all.equal(result$encrypted, test$`Answer Expected`)
#> [1] TRUE
