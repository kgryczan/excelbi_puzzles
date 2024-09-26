library(tidyverse)
library(readxl)

path = "Excel/119 TRIM.xlsx"
input = read_excel(path, range = "A1:A8")
test  = read_excel(path, range = "B1:B8")

result = input %>%
  mutate(String = str_remove_all(String, "^_+|_+$"))

all.equal(result$String, test$Result, check.attributes = FALSE)
#> [1] TRUE