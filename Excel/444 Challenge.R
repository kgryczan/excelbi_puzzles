library(tidyverse)
library(readxl)

input = read_excel("Excel/443 Look and Say Sequence.xlsx", range = "A1:A10")
test  = read_excel("Excel/443 Look and Say Sequence.xlsx", range = "B1:B10")


generate_next = function(number) {
  number_str = as.character(number)
  digits = str_split(number_str, "")[[1]]
  
  unique_digits = unique(digits)
  
  result = map_chr(unique_digits, function(digit) {
    count = sum(digits == digit)
    paste0(count, digit)
  }) %>% paste0(collapse = "")
  
  as.numeric(result)
}

generate_sequence = function(start_digit, iter = 4) {
  result = start_digit
  
  for (i in 1:iter) {
    next_number = generate_next(result[length(result)])
    result = c(result, next_number)
  }
  
  all = result %>%
    setdiff(., start_digit) %>%
    paste0(collapse = ", ")
  
  return(all)
}

result = input %>%
  mutate(`Answer Expected` = map_chr(Numbers, generate_sequence))

identical(result$`Answer Expected`, test$`Answer Expected`)
# [1] TRUE
