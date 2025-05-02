library(tidyverse)
library(readxl)

path = "Excel/698 Alignment of Data.xlsx"
input = read_excel(path, range = "A2:A24")
test = read_excel(path, range = "C2:J7")

result = input %>%
  mutate(
    rn = row_number(),
    rn2 = match(Alphabets, LETTERS),
    .by = Alphabets
  ) %>%
  pivot_wider(names_from = rn, values_from = Alphabets) %>%
  arrange(rn2) %>%
  select(-rn2)

all.equal(result, test)
#> [1] TRUE
