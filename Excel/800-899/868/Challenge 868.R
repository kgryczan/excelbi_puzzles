library(tidyverse)
library(readxl)
library(stringi)

path <- "Excel/800-899/868/868 Mirrored Caesar Pi Cipher.xlsx"
input <- read_excel(path, range = "A1:A10")
test <- read_excel(path, range = "B1:B10")

reverse_words <- function(text) {
  str_split(text, " ") %>%
    map_chr(~ str_c(rev(.x), collapse = " "))
}

reverse_characters <- function(text) {
  str_split(text, " ") %>%
    map_chr(~ str_c(stringi::stri_reverse(.x), collapse = " "))
}

atbash_cipher <- function(text) {
  alphabet <- str_split("abcdefghijklmnopqrstuvwxyz", "", simplify = TRUE)
  atbash_alphabet <- rev(alphabet)
  char_map <- set_names(atbash_alphabet, alphabet)

  str_split(text, "", simplify = TRUE) %>%
    map_chr(~ ifelse(.x %in% names(char_map), char_map[.x], .x)) %>%
    str_c(collapse = "")
}

pi_code = function(text) {
  pi_digits <- c(3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5, 8, 9, 7, 9, 3, 2, 3, 8, 4)
  text_chars <- str_split(text, "", simplify = TRUE)
  pi_idx <- 1
  shifted_chars <- character(length(text_chars))
  for (i in seq_along(text_chars)) {
    char <- text_chars[i]
    if (char == " ") {
      shifted_chars[i] <- " "
    } else if (grepl("[a-z]", char)) {
      shift <- pi_digits[pi_idx]
      orig_pos <- match(char, letters)
      new_pos <- ((orig_pos - 1 + shift) %% 26) + 1
      shifted_chars[i] <- letters[new_pos]
      pi_idx <- pi_idx + 1
      if (pi_idx > length(pi_digits)) pi_idx <- 1
    } else {
      shifted_chars[i] <- char
    }
  }
  str_c(shifted_chars, collapse = "")
}

encode = . %>%
  reverse_characters() %>%
  reverse_words() %>%
  atbash_cipher() %>%
  pi_code()

result = input %>%
  mutate(`Answer Expected` = map_chr(`Plain Text`, encode))

all.equal(result$`Answer Expected`, test$`Answer Expected`)
result$`Answer Expected` == test$`Answer Expected`
