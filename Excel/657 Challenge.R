library(tidyverse)
library(readxl)

path = "Excel/657 Largest Alternating Even Odd or Odd Even Substring.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10")

generate_substrings <- function(num_str) {
  nchar_num_str <- nchar(num_str)
  unique(flatten_chr(map(seq_len(nchar_num_str), function(start) {
    map_chr(start:nchar_num_str, function(end) substr(num_str, start, end))
  })))
}

is_alternating <- function(num_str) {
  all(diff(as.numeric(strsplit(num_str, "")[[1]]) %% 2) != 0)
}

largest_alternating_substring <- function(number) {
  num_str <- as.character(number)
  valid_substrings <- generate_substrings(num_str) %>%
    map_chr(~ gsub("^0+", "", .x) %>% ifelse(. == "", "0", .)) %>%
    keep(is_alternating)
  if (length(valid_substrings) == 0) return(NA)
  max(valid_substrings[nchar(valid_substrings) == max(nchar(valid_substrings))])
}

result = input %>%
  mutate(LAS = map_chr(Numbers, largest_alternating_substring))

all.equal(result$LAS, test$`Answer Expected`, check.attributes = FALSE)
# [1] TRUE