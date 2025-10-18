library(tidyverse)
library(data.table)
library(readxl)

input = read_excel("Sort Text Numbers.xlsx", range = "A1:A10")
test = read_excel("Sort Text Numbers.xlsx", range = "B1:B10")


number_mappings <- function() {
  c("Zero" = 0, "One" = 1, "Two" = 2, "Three" = 3, "Four" = 4,
    "Five" = 5, "Six" = 6, "Seven" = 7, "Eight" = 8, "Nine" = 9)
}

word_to_number <- function(word) {
  numbers <- number_mappings()
  numbers[word]
}

number_to_word <- function(number) {
  words <- names(number_mappings())
  name_mapping <- setNames(names(number_mappings()), number_mappings())
  name_mapping[as.character(number)]
}

process_number_string <- function(num_string) {
  words <- str_extract_all(num_string, "[A-Z][a-z]*")[[1]]
  digits <- map_int(words, word_to_number)
  sorted_digits <- sort(digits, decreasing = TRUE)
  sorted_words <- map(sorted_digits, number_to_word)
  result_string <- paste0(unlist(sorted_words), collapse = "") 
  return(result_string)
}


result = input %>%
  rowwise() %>%
  mutate(remapped = map_chr(Number, process_number_string)) %>%
  ungroup()

identical(test$`Expected Answer`, result$remapped)