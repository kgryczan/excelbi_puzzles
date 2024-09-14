library(tidyverse)
library(readxl)

path = "Excel/006 How many duplicates entries.xlsx"
input = read_excel(path, range = "A1:B20")
test = c(4, 8)

result = input %>%
  mutate(nr = n(), .by = Data) %>%
  filter(nr >= 2) %>%
  filter("B" %in% Alpha & "C" %in% Alpha, .by = Data) %>%
  pull(Data) %>%
  unique()

all.equal(result, test)
#> [1] TRUE