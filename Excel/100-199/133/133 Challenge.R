library(tidyverse)
library(readxl)

path = "Excel/133 Max Min Authors.xlsx"
input = read_excel(path, range = "A1:C20")
test  = read_excel(path, range = "E1:E3")

result = input %>%
  mutate(n = n(), 
         min = min(Sold),
         max = max(Sold),
         diff = max - min,
         .by = Author) %>%
  filter(n != 1) %>%
  select(Author, diff) %>%
  distinct() %>%
  slice_max(diff, n = 1) %>%
  select(Author)

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE