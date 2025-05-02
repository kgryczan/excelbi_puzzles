library(tidyverse)
library(readxl)

path = "Excel/189 Count of Elements GT.xlsx"
input = read_excel(path, range = "A1:A20")
test  = read_excel(path, range = "B1:B20")

result = input %>%
  mutate(
    sum_bigger = map_dbl(row_number(), ~ sum(Numbers[.x:n()] > Numbers[.x]))
  )

all.equal(result$sum_bigger, test$`Answer Expected`)
#> [1] TRUE