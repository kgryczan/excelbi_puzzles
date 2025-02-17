library(tidyverse)
library(readxl)

path = "Excel/654 Percentage Within a Subgroup.xlsx"
input = read_excel(path, range = "A1:C13")
test  = read_excel(path, range = "D1:D13")

result = input %>%
  mutate(`Answer Expected` = Revenue/sum(Revenue), .by = Group)

all.equal(result$`Answer Expected`, test$`Answer Expected`, check.attributes = FALSE)
#> [1] TRUE