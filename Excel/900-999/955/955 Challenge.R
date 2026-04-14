library(tidyverse)
library(readxl)

path <- "900-999/955/955 Longest Valid Parentheses.xlsx"
input <- read_excel(path, range = "A1:A18")
test <- read_excel(path, range = "B1:B18")

scan_for_parenthesis_seqs = function(str) {
  string = str_split(str, "")[[1]]
  scan = function(chars, open, close) {
    left = right = best = 0

    for (char in chars) {
      left = left + (char == open)
      right = right + (char == close)
      if (left == right) {
        best = max(best, left + right)
      } else if (right > left) {
        left = right = 0
      }
    }
    best
  }
  return(max(scan(string, "(", ")"), scan(rev(string), ")", "(")))
}

result = input %>%
  mutate(`Answer Expected` = map_dbl(Data, scan_for_parenthesis_seqs))

all.equal(result$`Answer Expected`, test$`Answer Expected`)
# [1] TRUE
