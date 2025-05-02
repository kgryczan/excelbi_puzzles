library(tidyverse)
library(readxl)

input = read_excel("Excel/456 Extract special Characters.xlsx", range = "A1:A10")
test  = read_excel("Excel/456 Extract special Characters.xlsx", range = "B1:B10")

# approach 1 - remove alphanumerics 

result = input %>%
  mutate(String = str_replace_all(String, "[[:alnum:]]", "")) %>%
  mutate(String = ifelse(String == "", NA, String))

identical(result$String, test$`Expected Answer`)
#> [1] TRUE

# approach 2 - extract special characters

result2 = input %>%
  mutate(String = str_extract_all(String, "[^[:alnum:]]") %>%
           map_chr(~paste(.x, collapse = ""))) %>%
  mutate(String = ifelse(String == "", NA, String))

identical(result2$String, test$`Expected Answer`)
#> [1] TRUE