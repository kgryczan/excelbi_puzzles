library(tidyverse)
library(readxl)

path = "Excel/522 Express as Sum of Consecutive Odd Numbers.xlsx"
input = read_excel(path, range = "A1:A8")
test  = read_excel(path, range = "B1:B8")

find_sum_consecutive <- function(n) {
  odd_numbers <- seq(1, n - 1, by = 2)
  for (start in seq_along(odd_numbers)) {
    for (length in 2:(length(odd_numbers) - start + 1)) {
      end <- start + length - 1
      if (end > length(odd_numbers)) {
        break
      }
      current_sum <- sum(odd_numbers[start:end])
      if (current_sum == n) {
        return(paste(odd_numbers[start:end], collapse = ", "))
      }
      if (current_sum > n) {
        break
      }
    }
  }
  return("NP")
}

result = input %>%
  mutate(`Answer Expected` = map_chr(Number, find_sum_consecutive)) %>%
  select(-Number)

identical(result, test)
# [1] TRUE