library(tidyverse)
library(readxl)

path = "Excel/706 Running Total for Even & Odd.xlsx"
input = read_excel(path, range = "A1:A30")
test = read_excel(path, range = "B1:B30")

result = input %>%
  mutate(odd_even = ifelse(Numbers %% 2 == 0, "even", "odd")) %>%
  mutate(result = cumsum(Numbers), .by = odd_even) %>%
  select(-odd_even)

all.equal(result$result, test$`Answer Expected`)
# [1] TRUE
