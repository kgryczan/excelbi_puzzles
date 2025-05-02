library(tidyverse)
library(readxl)

path = "Excel/560 Vowels between Consonants.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10") %>% replace_na(list(`Answer Expected` = ""))

extract_cvc_overlap <- function(input_string) {
  pattern <- "(?=([^aeiou][aeiou]+[^aeiou]))"
  str_match_all(input_string, pattern) %>%
    map_chr(~ paste(.[, 2], collapse = ", ")) %>%
    str_trim()
}

result = input %>%
  mutate(result = map_chr(Words, extract_cvc_overlap))

all.equal(result$result, test$`Answer Expected`, check.attributes = FALSE)
#> [1] TRUE