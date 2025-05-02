library(tidyverse)
library(readxl)

path = "Excel/016 Select Immediate Next & Prior.xlsx"
input = read_excel(path, range = "A1:A20")
test  = read_excel(path, range = "B1:B6")

result = input %>%
  filter(lag(Birds)== "SELECT" | lead(Birds) == "SELECT")

identical(result$Birds, test$`Answer Expected`)
# [1] TRUE