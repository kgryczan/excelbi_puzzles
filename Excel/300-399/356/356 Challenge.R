library(tidyverse)
library(readxl)

input = read_excel("Excel/356 Count Digit Frequencies.xlsx", range = "A1:A10")
test  = read_excel("Excel/356 Count Digit Frequencies.xlsx", range = "B1:B10")

evaluate = function(number) {
  result = str_split(number, "")[[1]] %>%
    table() %>%
    as.data.frame() %>%
    select(digit = 1, freq = 2) %>%
    mutate(digit = as.numeric(as.character(digit)),
           freq_of_max = freq[which.max(digit)]) %>%
    filter(freq > freq_of_max) %>%
    pull(digit) %>%
    paste0(collapse = ", ") %>%
    ifelse(nchar(.) == 0, NA, .)
  return(result)  
}

result = input %>%
  mutate(Digits = map_chr(Numbers, evaluate))

identical(result$Digits, test$Digits)
# [1] TRUE