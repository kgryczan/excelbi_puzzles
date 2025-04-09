library(tidyverse)
library(readxl)

path = "Excel/691 Ranking.xlsx"
input = read_excel(path, range = "A2:B15")
test  = read_excel(path, range = "C2:D15")

result = input %>%
  mutate(Rank1 = dense_rank(Score)) %>%
  mutate(Rank2 = row_number()/100 + Rank1, .by = Rank1) %>%
  select(Rank1, Rank2)

all.equal(result, test)
#> [1] TRUE