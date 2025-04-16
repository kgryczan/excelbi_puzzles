library(tidyverse)
library(readxl)
library(numbers)

path = "Excel/228 Deficient Perfect Abundant Numbers.xlsx"
input = read_excel(path, range = "A1:A10")
test = read_excel(path, range = "B1:B10")

result =
  input %>%
  mutate(
    sum_of_divisors = map_dbl(Numbers, ~ sum(divisors(.x)) - .x),
    type = case_when(
      sum_of_divisors < Numbers ~ "Deficient",
      sum_of_divisors == Numbers ~ "Perfect",
      sum_of_divisors > Numbers ~ "Abundant"
    )
  ) %>%
  select(type)

all.equal(result$type, test$`Answer Expected`)
# [1] TRUE
