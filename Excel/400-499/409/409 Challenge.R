library(tidyverse)
library(readxl)

input = read_excel("Excel/409 Table_Regular.xlsx", range = "A1:E12")
test  = read_excel("Excel/409 Table_Regular.xlsx", range = "G1:K29")

result = input %>%
  fill(c(1,5), .direction = "down") %>%
  mutate(Items = str_split(Items, ", ")) %>%
  unnest_longer(Items)

identical(result, test)  
#> [1] TRUE
