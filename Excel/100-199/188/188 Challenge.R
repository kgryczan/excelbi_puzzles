library(tidyverse)
library(readxl)

path = "Excel/188 Sort Columns.xlsx"
input = read_excel(path, range = "A1:E8")
test  = read_excel(path, range = "G1:K8")

sort_column = function(col) {
  nrow = length(col)
  df = tibble(col = col) %>%
  na.omit() %>%
  mutate(freq = n(), .by = col) %>%
  arrange(desc(freq), desc(col)) %>%
  select(col)
  df = bind_rows(df, tibble(col = rep(NA, nrow - nrow(df))))
  return(df)
}

result = input %>%
  map(sort_column) %>%
  bind_cols()

names(test) = names(result)

all.equal(result, test)
#> [1] TRUE