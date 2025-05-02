library(tidyverse)
library(readxl)

path = "Excel/191 Ranking.xlsx"
input = read_excel(path, range = "A1:D6")
test  = read_excel(path, range = "E1:E6")

result = input %>%
  mutate(sum = rowSums(select(., -Player))) %>%
  mutate(rank = rank(-sum, ties.method = "first"))

all.equal(result$rank, test$`Expected Answer`)
#> [1] TRUE