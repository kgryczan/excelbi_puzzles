library(tidyverse)
library(readxl)

path = "Excel/063 US Presidents_2.xlsx"
input = read_excel(path, range = "A1:A47")
test  = read_excel(path, range = "B2:C6")

result = input %>%
  mutate(name = str_to_upper(`US Presidents`)) %>%
  pull(name) %>%
  paste(collapse = "") %>%
  str_replace_all("[^[:alpha:]]", "") %>%
  str_split("") %>%
  table() %>%
  as_tibble() %>%
  slice_max(n, n = 3)

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE