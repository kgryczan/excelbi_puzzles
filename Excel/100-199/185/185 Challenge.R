library(tidyverse)
library(readxl)

path = "Excel/185 First Digit is Equal to Sum of Remaining Digits.xlsx"
input = read_excel(path, range = "A1:B6")
test  = read_excel(path, range = "D1:F6")

generate_special_numbers = function(min_range, max_range) {
  candidates = min_range:max_range
  valid_numbers = candidates[sapply(candidates, function(num) {
    digits = as.numeric(unlist(strsplit(as.character(num), "")))
    first_digit = digits[1]
    other_digits_sum = sum(digits[-1])
    first_digit == other_digits_sum
  })]
  return(valid_numbers)
}

generate_special_numbers(100, 657)

result = input %>%
  mutate(nums = map2(From, To, generate_special_numbers)) %>%
  mutate(Count = map_dbl(nums, length),
            Smallest = map_dbl(nums, min),
            Largest = map_dbl(nums, max))

result = result %>%
  select(-c(nums, From, To))

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE