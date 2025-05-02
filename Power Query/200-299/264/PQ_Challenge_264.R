library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_264.xlsx"
input = read_excel(path, range = "A1:E7")
test  = read_excel(path, range = "A11:F17")

result = input %>%
  pivot_longer(-c(1), names_to = "col", values_to = "Alphabet", values_drop_na = T) %>%
  unite("Address", Row_Col, col, sep = "") %>%
  arrange(Alphabet, Address) %>%
  mutate(rn = row_number(), .by = Alphabet) %>%
  pivot_wider(names_from = rn, names_glue = "Address{rn}", values_from = Address)

all.equal(result, test, check.attributes = F)
#> [1] TRUE