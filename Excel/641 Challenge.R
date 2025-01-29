library(tidyverse)
library(readxl)

path = "Excel/641 Wrap the Row.xlsx"
input = read_excel(path, range = "A1:A12")
test  = read_excel(path, range = "B2:E6", col_names = c("N1", "N2", "N3", "N4"))

result = input %>%
  mutate(row = cumsum(if_else(is.na(lag(Numbers)) | abs(Numbers - lag(Numbers)) > 2, 1, 0))) %>%
  mutate(num = glue::glue("N{row_number()}"), .by = row) %>%
  pivot_wider(names_from = num, values_from = Numbers) %>%
  select(-row)

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE