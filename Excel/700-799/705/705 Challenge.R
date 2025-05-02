library(tidyverse)
library(readxl)

path = "Excel/705 Swap Alphabets and Numbers.xlsx"
input = read_excel(path, range = "A1:A10")
test = read_excel(path, range = "B1:B10")

result = input %>%
  mutate(rn = row_number()) %>%
  separate_rows(Words, sep = "") %>%
  filter(Words != "") %>%
  mutate(dig_alpha = ifelse(str_detect(Words, "[0-9]"), -1, 1)) %>%
  mutate(char_index = row_number(), .by = c("rn", "dig_alpha")) %>%
  mutate(
    rematch_index = char_index * dig_alpha,
    rematch_index2 = char_index * dig_alpha * -1
  )

r1 = result %>%
  left_join(
    result,
    by = c(
      "rematch_index" = "rematch_index2",
      "char_index" = "char_index",
      "rn" = "rn"
    )
  ) %>%
  summarise(
    Words = paste(Words.x, collapse = ""),
    Words2 = paste(Words.y, collapse = ""),
    .by = c("rn")
  )

all.equal(r1$Words2, test$`Answer Expected`)
#> True
