library(tidyverse)
library(readxl)

path = "Excel/678 Perfect Square Even if Reversed.xlsx"
test  = read_excel(path, range = "A2:B40")

is_square = function(n) {
  root = sqrt(n)
  root == floor(root)
}

reverse_digits_vec = function(n) {
  as.integer(sapply(n, function(x) paste0(rev(strsplit(as.character(x), "")[[1]]), collapse = "")))
}

n = 1:40000
squares = n^2
rev_squares = reverse_digits_vec(squares)

valid = is_square(rev_squares) & (squares %% 2 != rev_squares %% 2)
result = squares[valid][1:50] %>% 
    as_tibble() %>%
    mutate(evenodd = ifelse(value %% 2 == 0, "Even", "Odd")) %>%
    mutate(rn = row_number(), .by = evenodd) %>%
    pivot_wider(names_from = evenodd, values_from = value) %>%
    select(-rn)

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE