library(tidyverse)
library(readxl)

path = "Excel/072 Runners Up but Never Won Top 2.xlsx"
input = read_excel(path, range = "A1:C22")
test  = read_excel(path, range = "D2:E5")

result = input %>%
  filter(!`Runners-up` %in% Winners) %>%
  summarise(Count = n(), .by = `Runners-up`) %>%
  slice_max(Count, n = 2) %>%
  select(Country = `Runners-up`, Count)

all.equal(result, test)
#> [1] TRUE