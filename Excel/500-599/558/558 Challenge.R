library(tidyverse)
library(readxl)

path = "Excel/558 Unpack Dictionary.xlsx"
input = read_excel(path, range = "A2:A7")
test  = read_excel(path, range = "B2:C7")

result = input %>%
  mutate(rn = row_number()) %>%
  separate_rows(Dictionary, sep = ", ") %>%
  separate(Dictionary, c("Key", "Value"), sep = ":|;", extra = "merge") %>%
  summarise(Key = str_c(Key, collapse = ", "),
            Value = str_c(Value, collapse = ", "), .by = rn) %>%
  select(Key, Value)

all.equal(test, result)
#> [1] TRUE
