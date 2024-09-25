library(tidyverse)
library(readxl)

path = "Excel/106 Latest Data.xlsx"
input = read_excel(path, range = "A1:D18")
test  = read_excel(path, range = "F2:H6")

result = input %>%
  slice_max(Date, n = 1, by = Shop) %>%
  select(Shop, Price, Date) %>%
  arrange(Shop)

all.equal(result, test)
# [1] TRUE