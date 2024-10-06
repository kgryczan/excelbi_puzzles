library(tidyverse)
library(readxl)

path = "Excel/123 US Presidents_3.xlsx"
input = read_excel(path, range = "A1:A47")
test  = read_excel(path, range = "B1:B5")

result = input %>%
  separate_rows(`US Presidents`, sep = " ") %>%
  filter(nchar(`US Presidents`) > 2) %>%
  summarise(n = n(), .by = `US Presidents`) %>%
  slice_max(n = 3, order_by = n) %>%
  select(`Answer Expected` = `US Presidents`)
 
all.equal(result, test)
#> [1] TRUE