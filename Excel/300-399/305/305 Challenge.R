library(tibble)
library(purrr)
library(tidyverse)

generate_wave <- function(amp) {
  n_rows <- 2 * amp - 1
  generate_palindrome <- function(base) {
    sequence <- base:1
    number <- c(sequence, rev(sequence[-length(sequence)]))
    return(paste0(number, collapse = ""))
  }
  
  single_column <- rep(NA, n_rows)
  seq = c(1:amp, (amp-1):1)
  table = tibble(row = seq) %>%
    mutate(row_number = row_number(),
           col1 = map_chr(row, ~generate_palindrome(.x)),
           col2 = col1,
           col3 = col1,
           col4 = col1,
           col5 = col1) %>%
    mutate_at(vars(col1, col3, col5), 
              ~ifelse(row_number > amp, " ", .)) %>%
    mutate_at(vars(col2, col4), 
              ~ifelse(row_number < amp, " ", .)) %>%
    mutate_at(vars(col1, col2, col3, col4, col5), 
              ~str_pad(., max(nchar(.), na.rm = TRUE), side = "both")) %>%
    select(-c(row_number, row))
  return(table)
}

generate_wave(5)
