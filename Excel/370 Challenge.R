library(tidyverse)
library(stringi)
library(readxl)

test = read_excel("Excel/370 Palindromic Cyclops Number.xlsx", range = "A1:A1001") %>%
  mutate(`Expected Answer` = as.integer(`Expected Answer`))

generate_cyclopic_palindromes <- function(n) {
  half_parts <- seq(1, 10^n - 1) %>% 
    keep(~ !str_detect(.x, "0")) %>% 
    map_chr(~ paste0(.x, "0", stri_reverse(.x))) %>% 
    as.integer()
  
  half_parts
}

palindromic_cyclopic_numbers <- generate_cyclopic_palindromes(4) %>% 
  head(1000)

identical(palindromic_cyclopic_numbers, test$`Expected Answer`)
# [1] TRUE
