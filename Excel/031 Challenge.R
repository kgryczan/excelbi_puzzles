library(tidyverse)
library(readxl)

path = "Excel/031 Quarterly Revenue.xlsx"
input = read_excel(path, range = "A1:B20")
test  = read_excel(path, range = "D2:E6")

result = input %>%
  mutate(Quarter = paste0("Q", quarter(Date))) %>%
  summarise(Revenue = sum(Revenue), .by = Quarter)

identical(result, test)
#> [1] TRUE