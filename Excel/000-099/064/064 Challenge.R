library(tidyverse)
library(readxl)

path = "Excel/064 Find Repeated Digits Numbers.xlsx"
input = read_excel(path, range = "A1:A9")
test  = read_excel(path, range = "B1:B5")

result = input %>%
  mutate(digits = str_split(as.character(Numbers), ""),
         nchar = map_int(digits, length),
         unic_nchar = map_int(digits, ~length(unique(.x)))) %>%
  filter(unic_nchar != nchar) %>%
  select(Numbers)

identical(result$Numbers, test$`Answer Expected`)
#> [1] TRUE