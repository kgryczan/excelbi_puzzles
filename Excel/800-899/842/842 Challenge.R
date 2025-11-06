library(tidyverse)
library(readxl)

path = "Excel/800-899/842/842 Running Total.xlsx"
input = read_excel(path, range = "A2:C23")
test  = read_excel(path, range = "D2:D23")

result = input %>%
  mutate(`Running Total` = cumsum(Revenue), .by = Company)

all.equal(result$`Running Total`, test$`Running Total`)
# [1] TRUE