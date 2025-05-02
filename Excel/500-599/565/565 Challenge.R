library(tidyverse)
library(readxl)

path = "Excel/565 Even Number and Reversal Perfect Square.xlsx"
test  = read_excel(path, range = "A1:A51")

is_even = function(x) {
  x %% 2 == 0
}

is_perfect_square = function(x) {
  sqrt_x = sqrt(x)
  sqrt_x == floor(sqrt_x)
}

reverse_number = function(x) {
  as.numeric(paste(rev(strsplit(as.character(x), NULL)[[1]]), collapse = ""))
}

find_even_reverse_perfect_squares = function(n_required) {
  results = vector("list", n_required)
  count = 1
  n = 10
  
  while (count <= n_required) {
    square = n^2
    reverse_square = reverse_number(square)
    if (is_even(square) && is_even(reverse_square) &&
        is_perfect_square(reverse_square)) {
      results[[count]] = list(original = square, reverse = reverse_square)
      count = count + 1
    }
    n = n + 1
  }
  return(results)
}

result = find_even_reverse_perfect_squares(50) %>%
  map_df(~ .x)

all.equal(result$original, test$`Expected Answer`)
# [1] TRUE