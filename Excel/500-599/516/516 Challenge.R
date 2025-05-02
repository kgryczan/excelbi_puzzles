library(tidyverse)
library(readxl)

path = "Excel/516 Product of Digits of Result is Equal to Number.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10") %>% 
  mutate(`Answer Expected` = as.character(`Answer Expected`))

find_smallest_number_with_digit_product = function(n) {
  if (n == 0) return(10)
  if (n == 1) return(1)
  factors = c()
  for (i in 9:2) {
    while (n %% i == 0) {
      factors = c(factors, i)
      n = n / i
    }
  }
  if (n > 1) return("NP")
  return(paste(sort(factors), collapse = ""))
}

result = input %>%
  mutate(`Answer Expected` = map_chr(Number, find_smallest_number_with_digit_product)) %>%
  select(2)

identical(result, test)
# [1] TRUE