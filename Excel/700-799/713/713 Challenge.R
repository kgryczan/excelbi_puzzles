library(tidyverse)
library(readxl)

path = "Excel/700-799/713/713 Split and Extract.xlsx"
input = read_excel(path, range = "A2:B6")
test = read_excel(path, range = "D2:E12")

result = input %>%
  mutate(rn = row_number()) %>%
  separate_rows(Data, sep = ", ") %>%
  mutate(Value = Value * row_number(), .by = rn) %>%
  select(-rn)

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE
