library(purrr)
library(memoise)
library(readxl)
library(tidyverse)

path = "Excel/485 Pandovan Sequence.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10")


padovan <- function(n) {
  if (n <= 2) {
    return(1)
  } else {
    return(padovan_memo(n - 2) + padovan_memo(n - 3))
  }
}
padovan_memo = memoise(padovan)

result = input %>%
  mutate(`Answer Expectecd` = map_dbl(n, padovan_memo))

identical(result$`Answer Expectecd`, test$`Answer Expectecd`)
# [1] TRUE