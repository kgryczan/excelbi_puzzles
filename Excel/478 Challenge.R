library(tidyverse)
library(readxl)

path = "Excel/478 Merge Tables.xlsx"

input1 = read_excel(path, range = "A2:C9")
input2 = read_excel(path, range = "E2:H10")
test   = read_excel(path, range = "J2:M14")

result = input1 %>%
  full_join(input2, by = c("Org", "Year")) %>%
  arrange(Org, Year) %>%
  mutate(Sales = map2_dbl(Sales.x, Sales.y, ~ sum(c(.x, .y), na.rm = TRUE))) %>%
  select(Org, Year, Prime, Sales)

identical(result, test)
#> [1] TRUE