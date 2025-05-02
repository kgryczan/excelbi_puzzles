library(tidyverse)
library(readxl)

input = read_excel("Excel/460 Insert Dash Splitter.xlsx", range = "A1:B10")
test  = read_excel("Excel/460 Insert Dash Splitter.xlsx", range = "C1:C10")

split_by_dash = function(word, n) {
  str_split(word, "", simplify = TRUE) %>%
    rev() %>%
    split(rep(1:ceiling(length(.) / n), each = n, length.out = length(.))) %>%
    map(~paste0(rev(.), collapse = "")) %>%
    rev() %>%
    paste0(collapse = "-")
}

result = input %>%
  mutate(`Answer Expected` = map2_chr(String, N, split_by_dash)) %>%
  select(3)

identical(result, test)
# [1] TRUE