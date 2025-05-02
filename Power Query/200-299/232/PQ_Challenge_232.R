library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_232.xlsx"
input = read_excel(path, range = "A1:C7")
test  = read_excel(path, range = "E1:G13")

result = input %>%
  group_by(Store) %>%
  complete(Date = seq(min(Date), max(Date), by = "day")) %>%
  ungroup() %>%
  mutate(has_val = cumsum(!is.na(Quantity))) %>%
  fill(Quantity) %>%
  mutate(Quantity = cumsum(Quantity), .by = c(Store, has_val)) %>%
  select(-has_val)

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE