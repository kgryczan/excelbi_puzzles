library(tidyverse)
library(readxl)

path = "Excel/081 Interchange Position.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10")

result = input %>%
  mutate(gr = (row_number() + 1) %/% 2) %>%
  mutate(pos = row_number(), .by = gr) %>%
  arrange(gr, desc(pos)) %>%
  select(Data)

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE