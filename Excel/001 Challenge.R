library(tidyverse)
library(readxl)

path = "Excel/001 Excel Challenge.xlsx"
input = read_excel(path, range = "A1:A20")
test  = 8

result = input %>%
  mutate(words = str_count(Name, "\\w+")) %>%
  filter(words == 2) %>%
  count() %>%
  pull()

result == test
#> [1] TRUE