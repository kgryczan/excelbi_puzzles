library(tidyverse)
library(readxl)

path = "Excel/600 Smallest Coin Sums.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10")

find_lowest_impossible_sum = function(coins) {
  coins = as.numeric(str_split(coins, ",")[[1]])
  all_combinations = unlist(map(1:length(coins), ~ combn(coins, .x, sum, simplify = TRUE)))
  diff = setdiff(seq(min(coins), sum(coins)), all_combinations)
  if (length(diff) == 0) sum(coins) + 1 else diff[1]
}

result = input %>%
  mutate(result = map_dbl(Coins, find_lowest_impossible_sum)) %>%
  select(result)

all.equal(result$result, test$`Answer Expected`)
#> [1] TRUE