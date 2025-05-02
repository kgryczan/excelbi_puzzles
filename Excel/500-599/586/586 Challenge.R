library(tidyverse)
library(readxl)

path = "Excel/586 Lookup.xlsx"
input = read_excel(path, range = "A2:C18")
test  = read_excel(path, range = "E2:J10")

result = input %>%
  fill(Animals, .direction = "down") %>%
  mutate(Count = ifelse(Count > 20, "Y", "N")) %>%
  pivot_wider(names_from = Park, values_from = Count, values_fill = "NF") %>%
  arrange(Animals) %>%
  select(Animals, Park1, Park2, Park3, Park4, Park5)

all.equal(result, test)
#> [1] TRUE