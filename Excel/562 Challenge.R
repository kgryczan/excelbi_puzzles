library(tidyverse)
library(readxl)

path = "Excel/562 One Child Palindromes.xlsx"
test = read_excel(path, range = "A1:A1001")

has_one_child <- function(n) {
  nchar = nchar(n)
  if (nchar == 1) {
    return(FALSE)
  }
  grid_coord = expand.grid(1:nchar, 1:nchar)
  substrings = apply(grid_coord, 1, function(x) {
    substr(n, x[1], x[2])
  }) %>%
  as.numeric() %>%
  .[!is.na(.) & . != 0] %>%
  unique()
  
  substrings = substrings[substrings %% nchar == 0]
  return(length(substrings) == 1)
}

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


palindrome_df <- tibble(num_digits = 1:9) %>%
  mutate(palindromes = map(num_digits, generate_all_palindromes))
res = palindrome_df %>%
  unnest(cols = c(palindromes)) %>%
  mutate(palindromes = as.integer(palindromes),
         has_one_child = map_lgl(palindromes, has_one_child))
result = res %>%
  filter(has_one_child == TRUE, palindromes > 10) %>%
  head(1000) %>%
  select(palindromes)

all.equal(test$`Answer Expected`, result$palindromes, check.attributes = FALSE)
# [1] TRUE