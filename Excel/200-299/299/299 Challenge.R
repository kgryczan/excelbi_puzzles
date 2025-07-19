library(tidyverse)
library(readxl)

input = read_excel("Split_String_Two_Halves_Equal_Weight.xlsx")

split_word <- function(word) {
  word <- tolower(word)
  letter_vals <- unlist(strsplit(word, "")) %>%
    map_dbl(~ which(.x == letters))
  running_sum <- cumsum(letter_vals)
  midpoint <- sum(letter_vals) / 2
  position <- which.min(abs(running_sum - midpoint))
  paste0(substr(word, 1, position), "-", substr(word, position + 1, nchar(word)))
}

result = input %>%
  mutate(my_answer = map_chr(String, split_word),
         correct = my_answer == `Expected Answer`)