library(tidyverse)
library(readxl)

path <- "Excel/800-899/882/882 Reverse Add Palindrome.xlsx"
input <- read_excel(path, range = "A1:A51")
test <- read_excel(path, range = "B1:B51")

is_palindrome <- function(x) {
  s <- as.character(x)
  s == paste(rev(strsplit(s, "")[[1]]), collapse = "")
}

solve_pals <- function(n) {
  purrr::accumulate(
    .x = 0:1000,
    .init = n,
    .f = function(current, .) {
      rev_num <- as.numeric(paste0(
        rev(strsplit(as.character(current), "")[[1]]),
        collapse = ""
      ))
      current + rev_num
    }
  ) -> seqs
  idx <- purrr::detect_index(seqs, is_palindrome) - 1
  return(palindrome = seqs[[idx + 1]])
}

result = input %>%
  mutate(`Answer Expected` = map_dbl(Numbers, solve_pals))

all.equal(result$`Answer Expected`, test$`Answer Expected`)
# [1] TRUE
