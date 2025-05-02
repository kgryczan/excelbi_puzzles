library(tidyverse)
library(readxl)

path = "Excel/217 Atbash Cipher.xlsx"
input = read_excel(path, range = "A1:A7")
test  = read_excel(path, range = "B1:B7")

code_atbash = function(word){
  mapping = setNames(letters[1:26], letters[26:1])
  word_lower = tolower(word)
  upper = str_locate_all(word, "[A-Z]")[[1]][, 1]
  word_lower = str_split(word_lower, "")[[1]]
  coded = map_chr(word_lower, function(x){
    if (x %in% letters) {
      return(mapping[x])
    } else {
      return(x)
    }
  })
  coded[upper] = toupper(coded[upper])
  coded = paste(coded, collapse = "")
  return(coded)
}

result = input %>%
  mutate(Atbash = map_chr(Strings, code_atbash))

all.equal(result$Atbash, test$`Answer Expected`)
#> [1] TRUE