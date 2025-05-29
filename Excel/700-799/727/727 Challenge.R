library(tidyverse)
library(readxl)

path = "Excel/700-799/727/727 Remove Duplicates.xlsx"
input = read_excel(path, range = "A2:C15")
test = read_excel(path, range = "E2:G10")

result = input %>%
  summarise(Amount = last(Amount), .by = c("State", "Stock"))

all.equal(result, test)
#> [1] TRUE
