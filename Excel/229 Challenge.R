library(tidyverse)
library(readxl)

path = "Excel/229 Double Base Palindrome.xlsx"
input = read_excel(path, range = "A1:A10")
test = read_excel(path, range = "B1:B6")

is_palindrome <- function(x)
  x == paste(rev(strsplit(x, NULL)[[1]]), collapse = "")

convert_to_base = function(n, base) {
  if (n == 0) return(0)
  digits = c()
  while (n > 0) {
    digits = c(digits, n %% base)
    n = n %/% base
  }
  return(paste0(rev(digits), collapse = ""))
}

result = input %>%
  mutate(
    bin = map_chr(Numbers, ~ convert_to_base(.x, 2)),
    Numbers = as.character(Numbers)
  ) %>%
  rowwise() %>%
  mutate(
    is_palindrome = is_palindrome(Numbers),
    is_bin_palindrome = is_palindrome(bin)
  ) %>%
  filter(is_palindrome & is_bin_palindrome) %>%
  select(Numbers) %>%
  mutate(Numbers = as.numeric(Numbers))

all.equal(result$Numbers, test$`Answer Expected`)
# [1] TRUE
