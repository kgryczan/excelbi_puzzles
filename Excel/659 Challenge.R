library(tidyverse)
library(readxl)

path = "Excel/659 Cube Frequency of All Digits Same.xlsx"
test  = read_excel(path, range = "A1:A81")

find_numbers <- function(min_n = 10, max_n = 99999) {
  nums <- min_n:max_n
  keep(nums, ~ length(unique(table(str_split(as.character(.x^3), "", simplify = TRUE)))) == 1) %>%
    enframe(name = NULL, value = "Answer Expected") 
}

result <- find_numbers()

all.equal(result, test)
#> [1] TRUE