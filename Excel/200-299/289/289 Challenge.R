library(tidyverse)
library(readxl)

input = read_excel("Missing Parenthesis.xlsx")

balance_parentheses <- function(input_str) {
  sorted_chars <- strsplit(input_str, NULL)[[1]] %>% sort()
  
  char_counts <- table(sorted_chars)
  
  get_diff <- function(open_char, close_char) {
    open_count <- ifelse(is.na(char_counts[open_char]), 0, as.numeric(char_counts[open_char]))
    close_count <- ifelse(is.na(char_counts[close_char]), 0, as.numeric(char_counts[close_char]))
    
    diff_count <- open_count - close_count
    if (diff_count > 0) {
      return(paste0(rep(close_char, diff_count), collapse = ""))
    } else {
      return(paste0(rep(open_char, abs(diff_count)), collapse = ""))
    }
  }
  
  complement_str <- paste0(
    get_diff('(', ')'), 
    get_diff('[', ']'), 
    get_diff('{', '}')
  )
  
  return(complement_str)
}

result = input %>%
  mutate(my_answer = map_chr(.$String, balance_parentheses))