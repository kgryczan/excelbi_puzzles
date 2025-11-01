library(tidyverse)
library(readxl)

path = "Power Query/300-399/335/PQ_Challenge_335.xlsx"
input = read_excel(path, range = "A1:F7")
test  = read_excel(path, range = "A12:I15")

result = input %>%
  fill(Fruits) %>%
  pivot_longer(-c(Fruits, Quarters), names_to = "Quarter") %>%
  arrange(Fruits, Quarter) %>%
  pivot_wider(names_from = c(Quarters, Quarter), values_from = value,
              names_glue = "{Quarters}-{Quarter}", names_vary = "slowest")

all.equal(result, test, check.attributes = FALSE)
# [1] TRUE