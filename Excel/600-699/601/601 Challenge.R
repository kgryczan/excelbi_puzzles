library(tidyverse)
library(readxl)

path = "Excel/601 Count Sorted Words.xlsx"
input = read_excel(path, range = "A2:C11")
test  = read_excel(path, range = "E2:F5")

result = input %>%
  summarize(across(everything(), ~ sum(map_lgl(str_split(.x, ""), ~ all(.x == sort(.x)))))) %>%
  pivot_longer(everything(), names_to = "Words", values_to = "Count")

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE