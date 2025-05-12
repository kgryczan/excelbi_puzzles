library(tidyverse)
library(readxl)

path = "Excel/700-799/714/714 Sell Alignment.xlsx"
input = read_excel(path, range = "A2:B12")
test = read_excel(path, range = "D2:F5")

result = input %>%
  mutate(
    Instr = ifelse(str_ends(Produce, "N"), "Don't Sell", "Sell"),
    Produce = str_extract(Produce, "^[^ ]+")
  ) %>%
  pivot_wider(
    names_from = Instr,
    values_from = Produce,
    values_fn = ~ paste(sort(.), collapse = ", ")
  ) %>%
  arrange(Farmer)

all.equal(result, test)
#> [1] TRUE
