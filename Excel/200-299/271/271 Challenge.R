library(tidyverse)
library(readxl)

path = "Excel/200-299/271/271 Largest Substring.xlsx"
input = read_excel(path, range = "A1:B10")
test  = read_excel(path, range = "C1:C10")

get_all_substrings = function(string, length) {
  substrings = c()
  for (i in seq_len(nchar(string) - length + 1)) {
    substrings = c(substrings, substr(string, i, i + length - 1))
  }
  return(substrings)
}

result = input %>%
  mutate(substrings = map2(Numbers, Length, get_all_substrings)) %>%
  unnest(substrings) %>%
  mutate(substrings = as.numeric(substrings)) %>%
  slice_max(substrings, n = 1, by = Numbers) %>%
  distinct()

all.equal(result$substrings, test$`Answer Expected`, check.attributes = FALSE)
# > [1] TRUE