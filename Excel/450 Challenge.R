library(tidyverse)
library(readxl)

input = read_excel("Excel/450 Ranking.xlsx", range = "A1:C20")
test  = read_excel("Excel/450 Ranking.xlsx", range = "D1:D20")

result = input %>%
  mutate(rank = dense_rank(desc(Sales)), .by = Company)

all.equal(result$rank, test$`Answer Expected`)
# [1] TRUE