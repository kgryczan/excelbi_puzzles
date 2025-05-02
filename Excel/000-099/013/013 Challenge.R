library(tidyverse)
library(readxl)

path = "Excel/012 Common in All Columns.xlsx"
input = read_excel(path, range = "A1:C12")
test  = read_excel(path, range = "D1:D4") %>% arrange(`Answer Expected`)

result = input %>%
  pivot_longer(everything(), names_to = "group", values_to = "name") %>%
  mutate(nr = n_distinct(group), .by = name) %>%
  filter(nr == 3) %>%
  select(name) %>%
  distinct()

identical(result$name, test$`Answer Expected`)
#> [1] TRUE