library(tidyverse)
library(readxl)

input = read_excel("Excel/457 Extract Numbers in Parenthesises.xlsx", range = "A1:A10")
test  = read_excel("Excel/457 Extract Numbers in Parenthesises.xlsx", range = "B1:B10")

pattern = "(?<=\\()\\d+(?=\\))|(?<=\\[)\\d+(?=\\])|(?<=\\{)\\d+(?=\\})"

result = input %>%
  mutate(`Answer Expected` = map(String, ~str_extract_all(.x, pattern) %>% 
                                   map_chr(~paste(.x, collapse = ", ")))) %>%
  mutate(`Answer Expected` = map_chr(`Answer Expected`, ~ifelse(.x == "", NA, .x))) %>%
  select(-String)

identical(result, test)
# [1] TRUE