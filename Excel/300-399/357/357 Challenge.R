library(tidyverse)
library(readxl)

input = read_excel("Excel/357 Prepare Dictionary.xlsx", range = "A1:B7")
test  = read_excel("Excel/357 Prepare Dictionary.xlsx", range = "C1:C7")

process = function(key, value) {
  keys = strsplit(key, ", ")[[1]]
  values = strsplit(value, ", ")[[1]]
  tib = tibble(key = keys, value = values) %>%
    filter(!key %in% c("a","e","i","o","u")) %>%
    unite("dict", key, value, sep = ":") %>% 
    pull(dict) %>%
    paste0(., collapse = ", ") %>%
    ifelse(. == "", NA, .)
  return(tib)
}

result = input %>%
  mutate(dict = map2_chr(Key, Value, process))

identical(result$dict, test$`Answer Expected`)
#> [1] TRUE

