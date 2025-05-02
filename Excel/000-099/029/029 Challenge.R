library(tidyverse)
library(readxl)

path = "Excel/029 ISBN-10.xlsx"
input = read_excel(path, range = "A1:B10")
test  = read_excel(path, range = "C1:C5")

result = input %>%
  separate_rows(`ISBN-10`, sep = "") %>%
  filter(`ISBN-10` != "") %>%
  mutate(rn = row_number(), .by = `Top 10 Books`) %>%
  mutate(num = rn * as.numeric(`ISBN-10`),
         num = ifelse(rn == 10, num/10, num)) %>%
  select(`Top 10 Books`, num, rn) %>%
  pivot_wider(names_from = rn, values_from = num, names_prefix = "P_") %>%
  mutate(total = rowSums(select(., 2:10), na.rm = TRUE),
         rem = total %% 11) %>%
  filter(P_10 == rem) %>%
  select(`Top 10 Books`)

identical(result$`Top 10 Books`, test$`Answer Expected`)
#> [1] TRUE