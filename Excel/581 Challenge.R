library(tidyverse)
library(readxl)

path = "Excel/581 Increment Sequences.xlsx"
input = read_excel(path, range = "A1:A18")
test  = read_excel(path, range = "B1:B18")

result = input %>% 
  mutate(Answer_Expected = if_else(is.na(Column1), 0, cumsum(!is.na(Column1) & (is.na(lag(Column1)) | lag(Column1) != Column1))))

all.equal(result$Answer_Expected, test$`Answer Expected`)
#> [1] TRUE