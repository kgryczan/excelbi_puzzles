library(tidyverse)
library(stringi)
library(readxl)

input = read_excel("Excel/392 Collect Even and Odd from Backwards.xlsx", range = "A1:A10")
test  = read_excel("Excel/392 Collect Even and Odd from Backwards.xlsx", range = "B1:B10")

transform = function(string) {
  str_rev = stri_reverse(string)
  chars = str_split(str_rev, "")[[1]]
  even_chars = chars[seq_along(chars) %% 2 == 0] %>%
    paste0(collapse = "") 
  odd_chars = chars[seq_along(chars) %% 2 == 1] %>%
    paste0(collapse = "") 
  return(paste0(even_chars, odd_chars))
}

result = input %>%
  mutate(transformed = map_chr(String, transform)) 

identical(result$transformed, test$`Answer Expected`)
# [1] TRUE

