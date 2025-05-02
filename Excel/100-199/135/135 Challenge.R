library(tidyverse)
library(readxl)

path = "Excel/135 Sum Negative Numbers.xlsx"
input = read_excel(path, range = "A1:A9")
test  = read_excel(path, range = "B1:B9")

result = input %>%
  mutate(digits = str_extract_all(String, "-\\d+")) %>%
  mutate(digits = map(digits, ~as.numeric(.x))) %>%
  mutate(digits = map_dbl(digits, ~sum(.x))) 

all.equal(result$digits, test$`Expected Answer`, check.attributes = FALSE)
# [1] TRUE