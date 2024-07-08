library(tidyverse)
library(readxl)

path = "Excel/494 Tech Numbers.xlsx"
test = read_excel(path)


is_perfect_square = function(x) {
  sqrt_x = sqrt(x)
  return(sqrt_x == floor(sqrt_x))
}

has_even_number_of_digits = function(x) {
  return(nchar(x) %% 2 == 0)
}

table = tibble(x = 1:1e8) %>%
  mutate(x = as.numeric(x)) %>%
  filter(is_perfect_square(x)) %>%
  filter(has_even_number_of_digits(x)) %>%
  mutate(first_half = substr(x, 1, nchar(x) / 2),
         second_half = substr(x, nchar(x) / 2 + 1, nchar(x))) %>%
  filter((as.numeric(second_half) + as.numeric(first_half))**2 == x) %>%
  head(10) %>%
  select(x)


identical(table$x, test$`Answer Expected`)
# [1] TRUE