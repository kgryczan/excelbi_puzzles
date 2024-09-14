library(tidyverse)
library(readxl)

path = "Excel/023 Number Greater Than.xlsx"
input = read_excel(path, range = "A1:A20")
test  = read_excel(path, range = "B1:B5")

result = input %>%
  mutate(rn = row_number(),
         last_8 = max(which(Number == 8))) %>%
  filter(rn > last_8 & Number > 8) %>%
  select(Number)

identical(result$Number, test$`Answer Expected`)
# [1] TRUE