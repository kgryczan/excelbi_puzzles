library(tidyverse)
library(readxl)

path <- "Excel/800-899/897/897 Special Score.xlsx"
input <- read_excel(path, range = "A1:B10")
test <- read_excel(path, range = "C1:C10")

calc_score = function(x) {
  x = as.character(x)
  n = nchar(x)
  if (n < 3) {
    return(0)
  }
  scores = purrr::map_int(1:(n - 2), function(i) {
    triplet = substr(x, i, i + 2)
    digits = as.integer(strsplit(triplet, "")[[1]])
    peak = as.integer(digits[1] > digits[2] && digits[3] > digits[2])
    valley = 2L * as.integer(digits[1] < digits[2] && digits[3] < digits[2])
    return(peak + valley)
  })
  return(sum(scores))
}

result = input %>%
  rowwise() %>%
  mutate(seq = list(seq(`Range Start`, `Range End`, by = 1))) %>%
  mutate(`Answer Expected` = sum(sapply(seq, calc_score))) %>%
  select(`Answer Expected`) %>%
  ungroup()

all_equal(result, test)
# [1] TRUE
