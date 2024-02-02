library(tidyverse)
library(readxl)

input = read_excel("Excel/383 Extract Positive and Negative Numbers.xlsx", range = "A2:A10")
test  = read_excel("Excel/383 Extract Positive and Negative Numbers.xlsx", range = "B2:C10")

extract = function(input, sign) {
  numbers = input %>%
    str_extract_all(paste0(sign, "(\\d+)")) %>%
    unlist() %>%
    as.numeric() %>%
    abs() %>%
    unique() %>%
    str_c(collapse = ", ") 
  
  if (numbers == "") {
    numbers = NA_character_
  } else {
    numbers = numbers
  }
}

result = input %>%
  mutate(positive = map_chr(Strings, extract, "\\+"),
         negative = map_chr(Strings, extract, "\\-")) 

identical(result$positive, test$`Positive Numbers`)
# [1] TRUE

identical(result$negative, test$`Negative Numbers`)
# [1] TRUE