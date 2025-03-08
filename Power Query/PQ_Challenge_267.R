library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_267.xlsx"
input = read_excel(path, range = "A1:A62")
test  = read_excel(path, range = "C1:D62")

main = rep(1:10, 10:1)
rest_count = nrow(input) - length(main)
rest = rep(10 + 1:rest_count, 1)
groups = c(main, rest)

result = input %>%
  bind_cols(tibble(groups = groups)) %>%
  mutate(running_total = cumsum(Amount), .by = groups) %>%
  select(-groups)

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE