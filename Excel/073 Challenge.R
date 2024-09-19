library(tidyverse)
library(readxl)

path = "Excel/073 Most Played Finals.xlsx"
input = read_excel(path, range = "A1:C22")
test  = read_excel(path, range = "D2:E4")

result = input %>%
  rowwise() %>%
  mutate(Teams = list(sort(c(Winners, `Runners-up`)))) %>%
  mutate(Teams = str_c(Teams, collapse = "-")) %>%
  ungroup() %>%
  summarise(Times = n(), .by = Teams) %>%
  slice_max(Times, n = 2)

all.equal(result, test)
# [1] TRUE