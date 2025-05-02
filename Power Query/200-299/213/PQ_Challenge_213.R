library(tidyverse)
library(readxl)
library(janitor)

path = "Power Query/PQ_Challenge_213.xlsx"

T1 = read_excel(path, range = "A2:C8")
T2 = read_excel(path, range = "A12:C16")

test = read_excel(path, range = "F2:K9")

T_full = bind_rows(T1, T2) %>%
  separate_rows(Item, sep = ", ") %>%
  separate_rows(Group, sep = ", ") %>%
  pivot_wider(names_from = Item, values_from = Stock, values_fn = sum) %>%
  adorn_totals(c("row", "col")) 

all.equal(test, T_full, check.attributes = FALSE)
#> [1] TRUE