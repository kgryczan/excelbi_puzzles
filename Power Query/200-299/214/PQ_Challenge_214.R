library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_214.xlsx"
input = read_excel(path, range = "A1:C13")
test  = read_excel(path, range = "E1:J7")

result = input %>%
  arrange(Animals, .by = Zoo) %>%
  mutate(nr = row_number(), .by = Zoo) %>%
  pivot_wider(
    names_from = Zoo,
    values_from = c(Animals, Count),
    names_glue = "{.value}_{Zoo}"
  ) %>%
  select(contains("Zoo1"), contains("Zoo2"), contains("Zoo3"))

colnames(result) = colnames(test)
all.equal(result, test)
#> [1] TRUE