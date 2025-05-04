library(tidyverse)
library(readxl)

path = "PQ_Challenge_283.xlsx"
input = read_excel(path, range = "A1:C10")
test = read_excel(path, range = "E1:I4")

result = input %>%
  pivot_wider(names_from = Dept, values_from = Amount, names_prefix = "Dept ") %>%
  select(ID, order(colnames(.)))

all.equal(result, test)
#> [1] TRUE
