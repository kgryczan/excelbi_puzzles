library(tidyverse)
library(readxl)

path = "Excel/613 Sum of Digits Sequence.xlsx"
test  = read_excel(path, range = "A1:A10001") %>% pull()

sum_of_digits <- function(n) {
  sum(as.numeric(strsplit(as.character(n), "")[[1]]))
}

sequence <- accumulate(1:10000, ~ .x + sum_of_digits(.x), .init = 1) %>%
  c(1, .) %>%
  head(-2)

all.equal(sequence, test)
#> [1] TRUE