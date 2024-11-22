library(tidyverse)
library(readxl)

path = "Excel/593 Extract the Numbers.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:D10", col_types = "numeric")
names(test) = c("1", "2", "3")

patt  = "[-\\d.,()]+"
result = input %>%
  mutate(nums = str_extract_all(Strings, patt)) %>%
  unnest(nums, keep_empty = T) %>%
  mutate(nums = as.numeric(str_replace_all(str_replace_all(nums, "\\(", "-"), "[,\\)]", ""))) %>%
  mutate(nn = row_number(), .by = Strings) %>%
  pivot_wider(names_from = nn, values_from = nums) %>%
  select(`1`, `2`, `3`)

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE
