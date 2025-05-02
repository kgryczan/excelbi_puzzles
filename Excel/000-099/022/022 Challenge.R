library(tidyverse)
library(readxl)

path = "Excel/022 Valid IP Addresses.xlsx"
input = read_excel(path, range = "A1:A12")
test  = read_excel(path, range = "C1:C5")

result = input %>%
  mutate(nr = row_number()) %>%
  separate_rows(`IP Address`, sep = "\\.") %>%
  group_by(nr) %>%
  mutate(`IP Address` = as.numeric(`IP Address`)) %>%
  filter(`IP Address` >= 0 & `IP Address` <= 255) %>%
  mutate(n_elem = n()) %>%
  filter(n_elem == 4) %>%
  summarise(`IP Address` = paste(`IP Address`, collapse = ".")) %>%
  ungroup()

identical(result$`IP Address`, test$`Answer Expected`)
#> [1] TRUE