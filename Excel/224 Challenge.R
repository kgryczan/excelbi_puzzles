library(tidyverse)
library(readxl)

path = "Excel/224 Numbers Subtract Odd and Even Positions Sum.xlsx"
input = read_excel(path, range = "A1:A10")
test = read_excel(path, range = "B1:B5")

sum_odd_even <- function(x) {
  x = as.numeric(strsplit(x, "")[[1]])
  odd_pos = x[seq(1, length(x), 2)]
  even_pos = x[seq(2, length(x), 2)]
  return(sum(odd_pos) - sum(even_pos))
}

result = input %>%
  mutate(Result = map_dbl(Numbers, sum_odd_even)) %>%
  filter(Result %% 2 == 0) %>%
  select(Numbers)

all.equal(result$Numbers, test$`Answer Expected`)
# [1] TRUE
