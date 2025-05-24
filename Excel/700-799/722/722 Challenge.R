library(tidyverse)
library(readxl)

path = "Excel/722 Remove the Minimum Row.xlsx"
input = read_excel(path, range = "A2:B12")
test = read_excel(path, range = "D2:E8")

result = input %>%
  filter(Amount != min(Amount), .by = Product)

all.equal(result, test)
#> [1] TRUE
