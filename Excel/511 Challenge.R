library(tidyverse)
library(readxl)
library(hunspell)

path = "Excel/511 Pig Latin Decrypter.xlsx"
input = read_excel(path, range = "A1:A10")
test = read_excel(path, range = "B1:B10")

rotate_word <- function(word, n) {
  len <- nchar(word)
  if (n >= len) return(word)
  substr(word, n + 1, len) %>% paste0(substr(word, 1, n))
}
decrypt_pig_latin <- function(sentence) {
  words <- str_split(sentence, " ")[[1]]
  decrypted_words <- words %>% map_chr(~ {
    word <- str_remove(.x, "ay[[:punct:]]?$")
    punctuation <- str_extract(.x, "[[:punct:]]$")
    len <- nchar(word)
    possible_words <- map_chr(0:(len - 1), ~ rotate_word(word, .x))
    valid_words <- possible_words %>% keep(hunspell_check)
    if (length(valid_words) > 0) {
      concatenated_valid_words <- paste(valid_words, collapse = "/")
      if (!is.na(punctuation)) {
        return(paste0(concatenated_valid_words, punctuation))
      } else {
        return(concatenated_valid_words)
      }
    } else {
      return(.x)
    }
  })
  paste(decrypted_words, collapse = " ")
}

result = input %>%
  mutate(`Answer Expected` = map_chr(`Encrypted Text`, decrypt_pig_latin)) %>%
  select(`Answer Expected`)

result == test
# Answer Expected
# [1,]            TRUE
# [2,]            TRUE
# [3,]            TRUE
# [4,]            TRUE
# [5,]            TRUE
# [6,]            TRUE
# [7,]            TRUE
# [8,]            FALSE who/how was your weekend?
# [9,]            TRUE