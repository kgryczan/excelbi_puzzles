library(tidyverse)
library(readxl)

path = "Excel/134 More than One Animal.xlsx"
input = read_excel(path, range = "A1:A6")
test  = read_excel(path, range = "B1:B6")

result = input %>%
  mutate(rn = row_number()) %>%
  separate_rows(Animals, sep = ", ") %>%
  mutate(rn2 = row_number(), .by = c(rn, Animals)) %>%
  mutate(max_rn2 = max(rn2), .by = c(rn, Animals)) %>%
  mutate(rn2 = ifelse(max_rn2 == 1, "", rn2)) %>%
  unite(Animals, c(Animals, rn2), sep = "") %>%
  summarise(Animals = paste0(Animals, collapse = ", "), .by = rn) %>%
  select(-rn)

all.equal(result, test, check.attributes = FALSE)
# [1] TRUE