library(tidyverse)
library(readxl)

path = "Excel/495 Sum of N Digit Palindrome Numbers.xlsx"
input = read_xlsx(path, range = "A2:A9")
test  = read_xlsx(path, range = "B2:C9")

generate_all_palindromes <- function(num_digits) {
  if (num_digits < 1) {
    stop("Number of digits must be at least 1")
  }
  if (num_digits == 1) {
    return(0:9)
  }
  half_digits <- ceiling(num_digits / 2)
  start_num <- 10^(half_digits - 1)
  end_num <- 10^half_digits - 1
  palindromes <- vector("integer", length = 0)
  
  for (i in start_num:end_num) {
    num_str <- as.character(i)
    rev_str <- paste0(rev(strsplit(num_str, "")[[1]]), collapse = "")
    if (num_digits %% 2 == 0) {
      palindrome_str <- paste0(num_str, rev_str)
    } else {
      palindrome_str <- paste0(num_str, substring(rev_str, 2))
    }
    palindromes <- c(palindromes, as.integer(palindrome_str))
  }
  return(palindromes)
}

result = input %>%
  mutate(palindromes = map(N, generate_all_palindromes)) %>%
  mutate(Count = map_dbl(palindromes, length),
         Sum = map_dbl(palindromes, sum)) %>%
  select(Count, Sum)

identical(result, test)
# [1] TRUE
