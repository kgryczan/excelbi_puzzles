library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_265.xlsx"
input = read_excel(path, range = "A1:G6") 
test  = read_excel(path, range = "A10:C21")

result = input %>%
  pivot_longer(-Factory, names_to = c(".value", "set"), names_pattern = "([a-zA-Z]+)(\\d+)") %>%
  select(-set) %>%
  drop_na()

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE