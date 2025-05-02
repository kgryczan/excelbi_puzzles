library(tidyverse)
library(readxl)

input = read_excel("Excel/369 Faro Shuffle.xlsx", range = "A1:B12")
test  = read_excel("Excel/369 Faro Shuffle.xlsx", range = "C1:C12")

shuffle = function(input, type) {
  numbers  = str_extract_all(input, "\\d+")[[1]]
  len = length(numbers)
  p1 = numbers[1:(len/2)]
  p2 = numbers[(len/2 + 1):len]

  if (type == "In") {
    shuffle_deck = map2_chr(p2, p1, ~ paste0(.x, ", ", .y)) %>% paste0(collapse = ", ")
      } else {
    shuffle_deck = map2_chr(p1, p2, ~ paste0(.x, ", ", .y)) %>% paste0(collapse = ", ")
  }
  return(shuffle_deck)
}

result = input %>%
  mutate(Result = map2_chr(Numbers, Type, shuffle)) %>%
  bind_cols(test) %>%
  mutate(Correct = ifelse(Result == `Expected Answer`, "Yes", "No"))



