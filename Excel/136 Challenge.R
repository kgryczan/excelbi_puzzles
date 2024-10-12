library(tidyverse)
library(readxl)

path = "Excel/136 Masking Strings.xlsx"
input = read_excel(path, range = "A1:B7")
test  = read_excel(path, range = "C1:C7") 
test$`Answer Expected` = str_replace_all(test$`Answer Expected`, ",", "")

map_text_substitute = function(a, b) {
  s = str_split(a, pattern = "[ ,]+", simplify = TRUE) %>% str_to_lower()
  w = str_split(b, pattern = ",\\s*", simplify = TRUE) %>% str_to_lower()
  substituted = map_chr(
    str_split(a, pattern = "[ ,]+", simplify = TRUE), 
    ~ if_else(str_to_lower(.x) %in% w, str_dup("*", str_length(.x)), .x)
  )
  result = str_c(substituted, collapse = " ") %>%
    str_replace_all(" {2,}", ", ")
  return(result)
}

result = input %>%
  mutate(output = map2_chr(String, Words, map_text_substitute))

all.equal(result$output, test$`Answer Expected`, check.attributes = FALSE)
#> [1] TRUE
