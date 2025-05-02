library(tidyverse)
library(readxl)

path = "Excel/531 Numbers Divisible after Removing a Digit.xlsx"
test = read_excel(path, range = "A2:B502")


find_divisors = function(n) {
  digits = strsplit(as.character(n), NULL)[[1]]
  divisors = integer(0)
  
  for (i in seq_along(digits)) {
    reduced_number = as.integer(paste0(digits[-i], collapse = ""))
    if (reduced_number > 1 && n %% reduced_number == 0) {
      divisors = c(divisors, reduced_number)
    }
  }
  return(divisors)
}

find_numbers = function(count = 500, start = 101) {
  result = list()
  number = start
  while (length(result) < count) {
    if (number %% 10 != 0) {
      divisors = find_divisors(number)
      if (length(divisors) > 0) {
        result[[as.character(number)]] = divisors
      }
    }
    number = number + 1
  }
  return(result)
}
numbers_with_divisors = find_numbers()
numbers_with_divisors = map(numbers_with_divisors, unique)

df = tibble(
  Number = names(numbers_with_divisors) %>% as.numeric(),
  Divisors = I(unname(numbers_with_divisors))
) %>%
  mutate(Divisors = map_chr(Divisors, ~ paste(.x, collapse = ", ")))

identical(df, test) # TRUE