library(tidyverse)
library(readxl)

path = "Excel/132 Highest Jumped Player.xlsx"
input = read_excel(path, range = "A1:C11")
test  = read_excel(path, range = "E2:F6")
names(test) = str_remove(names(test), "\\.1")

result = input %>%
  na.omit() %>%
  mutate(diff = `2021`-`2022`) %>%
  filter(dense_rank(desc(diff)) <= 3) %>%
  arrange(desc(diff)) %>%
  select(Player, `Jumped Ranking` = diff)

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE