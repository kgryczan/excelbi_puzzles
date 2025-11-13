library(tidyverse)
library(readxl)

path = "Excel/800-899/847/847 Sorting.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10")

sort_within_cell = function(s) {
  str_extract_all(s, "[A-Z]\\d+")[[1]] %>%
    enframe() %>%
    separate(value, into = c("char", "num"), sep = 1, convert = TRUE) %>%
    arrange(num) %>%
    mutate(paired = str_c(char, num)) %>%
    pull(paired) %>%
    str_c(collapse = "")
}

input_processed = input %>%
  mutate(
    sorted_within = map_chr(Data, sort_within_cell),
    sum_weight = map_dbl(sorted_within, ~ str_extract_all(., "\\d+")[[1]] %>% 
                         as.numeric() %>% sum())) %>%
    arrange(sum_weight)

all.equal(input_processed$sorted_within,test$`Answer Expected`)
# [1] TRUE