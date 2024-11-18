library(tidyverse)
library(readxl)

path = "Excel/171 Repeated Substrings.xlsx"
input = read_excel(path, range = "A1:A7")
test  = read_excel(path, range = "B1:C7")

find_repeating_pattern = function(s) {
  n = nchar(s)
  patterns = map_chr(seq_len(n %/% 2), ~ substr(s, 1, .x))
  repeats = map_int(patterns, ~ n %/% nchar(.x))
  matched = map2_lgl(patterns, repeats, ~ strrep(.x, .y) == s)
  
  if (any(matched)) {
    idx = which(matched)[1]
    tibble(Substring = patterns[idx], Count = repeats[idx])
  } else {
    tibble(Substring = NA, Count = NA_integer_)
  }
}

result = input %>%
  mutate(Detected = map(String, find_repeating_pattern)) %>%
  unnest(Detected) %>%
  select(-String) 

all.equal(result, test, check.attributes = FALSE)
# [1] TRUE