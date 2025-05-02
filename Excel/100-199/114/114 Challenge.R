library(tidyverse)
library(readxl)

path = "Excel/114 Min_Max.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "C2:D5")

result = input %>%
  mutate(String = str_extract_all(String, "\\d+")) %>%
  unnest(String) %>%
  mutate(String = as.numeric(String)) %>%
  distinct()

answer = cbind(slice_max(result, n = 3, order_by = String), slice_min(result, n = 3, order_by = String))

all.equal(answer, test, check.attributes = FALSE)
#> [1] TRUE