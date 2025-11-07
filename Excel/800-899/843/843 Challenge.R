library(tidyverse)
library(readxl)

path = "Excel/800-899/843/843 Consecutive Index.xlsx"
input = read_excel(path, range = "A2:A23")
test  = read_excel(path, range = "B2:B23")

result = input %>%
  mutate(
    change = input != lag(input, default = first(input)),
    group = cumsum(change)) %>%
  mutate(group = ifelse(n() > 1, group, NA), .by = group) %>%
  mutate(group = dense_rank(group)) %>%
  select(Index = group)

all.equal(result, test)
# [1] TRUE