library(tidyverse)
library(readxl)

path = "Excel/190 Largest Pair Sum.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10")

result = input %>%
  mutate(rn = row_number()) %>%
  separate_rows(Numbers, sep = ", ") %>%
  mutate(N2 = lead(Numbers), .by = rn) %>%
  mutate(sum = as.numeric(Numbers) + as.numeric(N2)) %>%
  slice_max(sum, n = 1, by = rn) %>%
  mutate(pair = paste(Numbers, N2, sep = ", ")) %>%
  mutate(pair_sorted = map2_chr(Numbers, N2, ~paste(sort(c(.x, .y)), collapse = ", "))) %>%
  mutate(rn2 = row_number(), .by = c(rn, pair_sorted)) %>%
  filter(rn2 == 1) %>%
  summarise(result = paste0(pair, collapse = "; "), .by = rn) %>%
  select(result)

all.equal(result, test, check.attributes = FALSE)
# false in provided solution