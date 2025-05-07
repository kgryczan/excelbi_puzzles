library(tidyverse)
library(readxl)

path = "Excel/700-799/711/711 Generate a Sequence.xlsx"
input = read_excel(path, range = "A1:A6")
test = read_excel(path, range = "A1:K6")

extract_sequence <- function(start_num) {
  pad_and_extract <- function(n) {
    sq <- n^2
    sq_str <- ifelse(nchar(sq) < 8, sprintf("%08d", sq), as.character(sq))
    as.integer(substr(sq_str, 3, 6))
  }

  sequence <- start_num
  repeat {
    next_val <- pad_and_extract(tail(sequence, 1))
    if (next_val %in% sequence) break
    sequence <- c(sequence, next_val)
  }

  return(sequence)
}

result = input %>%
  mutate(seq = map(Number, ~ extract_sequence(.x))) %>%
  unnest(seq) %>%
  group_by(Number) %>%
  slice(-1) %>%
  filter(seq != 0) %>%
  mutate(rn = row_number()) %>%
  filter(rn <= 10) %>%
  ungroup() %>%
  pivot_wider(names_from = rn, values_from = seq)


result == test
