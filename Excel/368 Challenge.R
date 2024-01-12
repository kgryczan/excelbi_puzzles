library(tidyverse)
library(readxl)

input = read_excel("Excel/368 Multi Tap Cipher.xlsx", range = "A1:A10")
test  = read_excel("Excel/368 Multi Tap Cipher.xlsx", range = "B1:B10")

encode = function(word) {
  chars = str_split(word, "")[[1]]
  pos = match(chars, letters)
  tibble = tibble(
    Letter = chars,
    Position = pos,
    Button = calculate_button(pos),
    Taps = calculate_taps(pos),
    repetitions = (map2_chr(Button, Taps, ~ rep(.x, .y) %>% paste0(collapse = "")))
  ) %>%
    pull(repetitions) %>%
    str_c(collapse = "")
}

calculate_button <- function(letter_pos) {
  case_when(
    letter_pos <= 15 ~ ((letter_pos - 1) %/% 3) + 2,
    letter_pos <= 19 ~ 7,
    letter_pos <= 22 ~ 8,
    TRUE ~ 9
  )
}

calculate_taps <- function(letter_pos) {
  case_when(
    letter_pos <= 15 ~ ((letter_pos - 1) %% 3) + 1,
    letter_pos <= 19 ~ ((letter_pos - 16) %% 4) + 1,
    letter_pos <= 22 ~ ((letter_pos - 20) %% 3) + 1,
    TRUE ~ ((letter_pos - 23) %% 4) + 1
  )
}

result = input %>%
  mutate(`Answer Expected` = map_chr(Words, encode))

identical(result$`Answer Expected`, test$`Answer Expected`)
# [1] TRUE

