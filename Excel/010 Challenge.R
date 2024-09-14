library(tidyverse)
library(readxl)

path = "Excel/010 List of 2 Words.xlsx"
input = read_excel(path, range = "A1:A20")
test  = read_excel(path, range = "B1:B9")

result = input %>%
  mutate(words = str_count(Name, "\\w+")) %>%
  filter(words == 2) %>%
  select(Name)

identical(result$Name, test$`Answer Expected`)
#> [1] TRUE