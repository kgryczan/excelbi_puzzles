library(tidyverse)
library(readxl)

input = read_excel("Excel/379 All Elements Larger than Preceding one.xlsx", range = "A1:A10")
test  = read_excel("Excel/379 All Elements Larger than Preceding one.xlsx", range = "B1:B10")

check_succeeding <- function(numbers, index) {
  current <- numbers[index]
  succeeding <- numbers[(index + 1):length(numbers)]
  all(succeeding > current)
}

process_string <- function(string) {
  numbers <- str_split(string, ",\\s*")[[1]] %>% 
    as.numeric()

  result <- map_lgl(seq_along(numbers), ~check_succeeding(numbers, .)) %>%
    which() %>%
    map_chr(~ as.character(numbers[.])) %>%
    paste(collapse = ", ")
  
  result = ifelse(result == "", NA_character_, result)
  
  return(result)
}

result = input %>%
  mutate(`Answer Expected` = map_chr(Numbers, ~process_string(.x)))

identical(result$`Answer Expected`, test$`Answer Expected`)
#> [1] TRUE
