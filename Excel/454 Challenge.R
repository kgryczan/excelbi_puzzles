library(tidyverse)
library(readxl)

input = read_excel("Excel/454 Extraction of number of nodes.xlsx", range = "A1:A9")
test  = read_excel("Excel/454 Extraction of number of nodes.xlsx", range = "B1:B9")

replace_notation_with_range <- function(text_vector) {
  str_replace_all(text_vector, "\\d+ to \\d+", function(match) {
    numbers <- str_split(match, " to ") %>%
      unlist() %>%
      as.numeric()
    
    range <- seq(from = numbers[1], to = numbers[2])
    paste(range, collapse = ", ")
  })
}

count_numbers <- function(text_vector) {
  str_count(text_vector, "\\d+") %>%
    as.numeric()
}

result = input %>%
  mutate(Pronlem = str_to_lower(Pronlem)) %>%
  mutate(Pronlem = map_chr(Pronlem, replace_notation_with_range)) %>%
  mutate(Count = count_numbers(Pronlem)) %>%
  select(Count)

identical(result$Count, test$`Answer Expected`)
# [1] TRUE