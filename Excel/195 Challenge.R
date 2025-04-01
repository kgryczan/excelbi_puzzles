library(tidyverse)
library(readxl)

path = "Excel/195 Twin Prime Numbers.xlsx"
input = read_excel(path, range = "A1:B10")
test  = read_excel(path, range = "D1:E6")

is_prime = function(n) {
  if (n <= 1) return(FALSE)
  if (n == 2) return(TRUE)
  if (any(n %% 2:(n-1) == 0)) return(FALSE)
  return(TRUE)
}

result = input %>%
  rowwise() %>%
  mutate(a1 = is_prime(`Number 1`),
         a2 = is_prime(`Number 2`),
         a3 = abs(`Number 1` - `Number 2`)) %>%
  filter(a1 & a2 & a3 == 2) %>%
  select(-a1, -a2, -a3)

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE