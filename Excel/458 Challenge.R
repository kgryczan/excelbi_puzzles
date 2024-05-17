library(tidyverse)
library(readxl)

input = read_excel("Excel/458 Maximum Consecutive Uppercase Alphabets.xlsx", range = "A1:A11")
test  = read_excel("Excel/458 Maximum Consecutive Uppercase Alphabets.xlsx", range = "B1:B11")

get_longest_capital = function(string) {
  caps = str_extract_all(string, "[A-Z]+") %>% unlist()
  caps_len = ifelse(length(caps) == 0, NA, max(nchar(caps)))
  caps = caps[nchar(caps) == caps_len] %>% paste0(collapse = ", ")
  return(caps)
}

result = input %>%
  mutate(ans = map_chr(Words, get_longest_capital)) %>%
  mutate(ans = ifelse(ans == "", NA_character_, ans))

all.equal(result$ans, test$`Expected Answer`)
# [1] TRUE