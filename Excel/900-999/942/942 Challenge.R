library(tidyverse)
library(readxl)

path <- "900-999/942/942 Matrix.xlsx"
input <- read_excel(path, range = "A2:B22")
test <- read_excel(path, range = "D2:J8")

result = input %>%
  distinct(Order_ID, Product) %>%
  summarise(
    pairs = list(expand.grid(p1 = Product, p2 = Product)),
    .by = Order_ID
  ) %>%
  unnest(pairs) %>%
  count(p1, p2) %>%
  complete(p1, p2, fill = list(n = 0)) %>%
  pivot_wider(names_from = p2, values_from = n) %>%
  mutate(p1 = as.character(p1)) %>%
  arrange(p1) %>%
  select(Product = p1, sort(colnames(.)))

all.equal(result, test)
#> [1] TRUE
