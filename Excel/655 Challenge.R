library(tidyverse)
library(readxl)

path = "Excel/655 Increasing or Decreasing or None Sequences.xlsx"
input = read_excel(path, range = "A1:A8")
test  = read_excel(path, range = "B1:B8")

result = input %>%
  mutate(rn = row_number()) %>%
  separate_rows(Sequences, sep = ",", convert = TRUE) %>%
  mutate(diff = Sequences - lag(Sequences), .by = rn) %>%
  na.omit() %>%
  summarise(`Answer Expected` = case_when(all(diff > 0) ~ "I",
                               all(diff < 0) ~ "D",
                               TRUE ~ "N"), .by = rn) %>%
  select(-rn)

all.equal(result, test)
#> [1] TRUE