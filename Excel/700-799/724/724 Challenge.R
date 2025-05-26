library(tidyverse)
library(readxl)

path = "Excel/700-799/724/724 Reverse alphabets and numbers separately.xlsx"
input = read_excel(path, range = "A1:A11")
test = read_excel(path, range = "B1:B11")

reverse_independently ==
  function(x) {
    chars = stringr::str_split(x, "", simplify = TRUE)
    is_letter = stringr::str_detect(chars, "[a-zA-Z]")
    is_digit = stringr::str_detect(chars, "[0-9]")
    chars[is_letter] = rev(chars[is_letter])
    chars[is_digit] = rev(chars[is_digit])
    stringr::str_c(chars, collapse = "")
  }

result = input %>%
  mutate(Reversed = map_chr(Strings, reverse_independently))

all.equal(result$Reversed, test$`Answer Expected`, check.attributes = FALSE)
# [1] "1 string mismatch"
