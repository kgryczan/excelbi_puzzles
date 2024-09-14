library(tidyverse)
library(readxl)

path = "Excel/009 Case Sensitive VLOOKUP_Challenge.xlsx"
input = read_excel(path, range = "A1:B8")
test = 64280

company = "MSFT"

result = input %>%
  filter(Company == company) %>%
  pull(Revenue)

test == result
# [1] TRUE