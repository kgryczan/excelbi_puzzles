library(tidyverse)
library(readxl)
library(combinat)

path = "Excel/517 Arrange Numbers to Form Square Chains.xlsx"
input = read_excel(path, range = "A1:A10") %>% unlist()
test  = read_excel(path, range = "B1:B10") %>% unlist()

is_perfect_square <- function(x) {
  sqrt_x <- sqrt(x)
  sqrt_x == floor(sqrt_x)
}

is_valid_sequence <- function(nums) {
  all(map2_lgl(nums[-length(nums)], nums[-1], ~ is_perfect_square(.x + .y)))
}

find_valid_permutation <- function(nums) {
  permutations <- permn(nums)
  valid_perm <- keep(permutations, is_valid_sequence)
  if (length(valid_perm) > 0) {
    return(valid_perm[[1]])
  } else {
    return(NULL)
  }
}

result = find_valid_permutation(input)
all.equal(unname(result), unname(test))
# [1] TRUE