library(tidyverse)
library(readxl)

path <- "900-999/956/956 Minimum Digits to Remove to Make Perfect Square.xlsx"
input <- read_excel(path, range = "A1:A11")
test <- read_excel(path, range = "B1:B11")

is_perfect_square <- function(x) {
  if (is.na(x) || !is.finite(x) || x < 0) {
    return(FALSE)
  }
  s <- floor(sqrt(x))
  s * s == x
}

get_perfect_squares <- function(num) {
  digits <- str_split(as.character(num), "")[[1]]
  perfect_squares <- numeric(0)
  n_digits <- length(digits)
  if (is_perfect_square(num)) {
    perfect_squares <- c(perfect_squares, num)
  }
  if (n_digits < 2) {
    return(perfect_squares)
  }
  for (i in 1:(n_digits - 1)) {
    keep <- n_digits - i
    combinations <- combn(digits, keep)
    for (j in seq_len(ncol(combinations))) {
      candidate <- as.numeric(paste0(combinations[, j], collapse = ""))
      if (!is.na(candidate) && is_perfect_square(candidate)) {
        perfect_squares <- c(perfect_squares, candidate)
      }
    }
  }
  result <- unique(perfect_squares)
  max_len <- max(nchar(as.character(result)))
  result[nchar(as.character(result)) == max_len] %>%
    paste(collapse = ", ")
}

result = input %>%
  mutate(perfect_squares = map_chr(Numbers, get_perfect_squares))

all.equal(result$perfect_squares, test$`Answer Expected`)
# Case 3 has 2 more answers. and 7 is NA not "".
