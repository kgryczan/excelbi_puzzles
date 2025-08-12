library(tidyverse)
library(readxl)

path = "Excel/700-799/780/780 Profit.xlsx"
input = read_excel(path, range = "A2:D10")
test  = read_excel(path, range = "F2:I6")

result = input %>%
  fill(Org) %>%
  mutate(Profit = Revenue - Cost) %>%
  select(Org, Year, Profit) %>%
  pivot_wider(
    names_from = Year,
    values_from = Profit,
    values_fn = sum
  ) %>%
  select(Org, `2011`, `2012`, `2013`)

all.equal(result, test)
# > [1] TRUE