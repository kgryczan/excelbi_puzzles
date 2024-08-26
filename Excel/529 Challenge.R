library(tidyverse)
library(readxl)
library(rebus)

pattern <- "(?<=\\D)[+-]?\\d+[+-]?"


path = "Excel/529 Sum with Signs.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10")

result = input %>%
  mutate(numbers = str_extract_all(Strings, pattern)) %>%
  mutate(adj_num = map_dbl(numbers, 
                       ~sum(as.numeric(str_replace_all(.x, "[+-]", "")) * 
                            ifelse(str_detect(.x, "-"), -1, 1)), na.rm = TRUE))

identical(result$adj_num, test$`Answer Expected`)
#> [1] TRUE
