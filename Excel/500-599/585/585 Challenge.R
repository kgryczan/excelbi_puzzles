library(tidyverse)
library(readxl)

path = "Excel/585 List the Factorials.xlsx"
input = read_excel(path, range = "A2:A11")
test  = read_excel(path, range = "B2:C7")


is_factorial <- function(n) {
  if (n < 1)
    return(FALSE)
  factorial <- 1
  i <- 1
  while (factorial < n) {
    i <- i + 1
    factorial <- factorial * i
  }
  return(factorial == n)
}

factorial_of <- function(n) {
  if (n < 1)
    return(NA)
  factorial <- 1
  i <- 1
  while (factorial < n) {
    i <- i + 1
    factorial <- factorial * i
  }
  return(ifelse(factorial == n, i, NA))
}

result = input %>%
  mutate(is_fact = map_lgl(Numbers, is_factorial)) %>%
  filter(is_fact) %>%
  mutate(`Factorial Of` = map_dbl(Numbers, factorial_of)) %>%
  select(-is_fact)

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE