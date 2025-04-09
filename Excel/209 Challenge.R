library(tidyverse)
library(readxl)

path = "Excel/209 Numbering of Characters.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10")

result = input %>%
  mutate(rn1 = row_number()) %>%
  separate_rows(Strings, sep = " ") %>%
  mutate(rn2 = row_number(), .by = rn1) %>%
  separate_rows(Strings, sep = "") %>%
  filter(Strings != "") %>%
  mutate(rn3 = row_number(), .by = c(rn1, rn2)) %>%
  mutate(code = paste0(rn3,".",Strings)) %>%
  summarise(`Answer Expected` = paste0(code, collapse = " "), .by = rn1)

all.equal(result$`Answer Expected`, test$`Expected Answer`)
#> [1] TRUE