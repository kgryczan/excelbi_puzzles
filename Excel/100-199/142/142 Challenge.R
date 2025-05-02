library(tidyverse)
library(readxl)

path = "Excel/142 Grid Summing.xlsx"
input = read_excel(path, range = "A1:E18")
test  = read_excel(path, range = "G1:K5")

result = input %>%
  summarise(across(everything(), sum, na.rm = TRUE), .by = `...1`) 

all.equal(result, test)
# [1] TRUE