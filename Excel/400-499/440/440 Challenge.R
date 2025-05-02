library(tidyverse)
library(readxl)

test = read_excel("Excel/440 List of Numbers Expressed as Sum of Two Squares.xlsx", range = "A1:A30")

is_sum_of_squares = function(x) {
  squares = (1:floor(sqrt(x)))^2
  any(map_lgl(squares,  ~ any(x == .x + squares[squares != .x])))
}

result = data.frame(numbers = 1:100 %>% as.numeric()) %>%
  filter(map_lgl(numbers, is_sum_of_squares))

identical(result$numbers, test$`Answer Expected`)
# [1] TRUE
