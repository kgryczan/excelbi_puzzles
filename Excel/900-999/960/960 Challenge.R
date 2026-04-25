library(tidyverse)
library(readxl)

path <- "900-999/960/960 Longest Substrings With Unique Chars.xlsx"
input <- read_excel(path, range = "A1:A15")
test <- read_excel(path, range = "B1:B15")

find_longest_unique_substrings <- function(s) {
  x <- expand_grid(i = seq_len(nchar(s)), j = seq_len(nchar(s))) %>%
    filter(i <= j) %>%
    pmap_chr(~ substr(s, ..1, ..2)) %>%
    keep(
      ~ {
        z <- strsplit(.x, "", TRUE)[[1]]
        length(z) == length(unique(z))
      }
    )
  paste(unique(x[nchar(x) == max(nchar(x))]), collapse = ",")
}
longest_substrings <- map_chr(input[[1]], find_longest_unique_substrings)
all.equal(longest_substrings, test["Answer Expected"][[1]])
# [1] TRUE
