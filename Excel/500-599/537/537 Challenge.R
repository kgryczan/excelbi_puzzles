library(tidyverse)
library(readxl)

path = "Excel/537 Minimum Product for Triplet.xlsx"
input = read_excel(path, range = "A1:F10")
test  = read_excel(path, range = "G1:G10")

output = input %>%
  mutate(min_product = pmap_dbl(., ~ min(combn(c(...), 3, prod))))

identical(test$`Answer Expected`, output$min_product) 
#> [1] TRUE
