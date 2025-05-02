library(tidyverse)
library(readxl)

path = "Excel/688 Sum of All Except First and Last Numbers.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B2") %>%
  pull()

result = input %>%
  mutate(numbers = str_extract_all(Strings, "\\d+"),
         numbers = map(numbers, ~ as.numeric(.x)),
         sum = map_dbl(numbers, ~ sum(.x[-c(1, length(.x))]))) %>%
  summarise(sum = sum(sum)) %>%
  pull()

test == result #> True
