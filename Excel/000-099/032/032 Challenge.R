library(tidyverse)
library(readxl)

path = "Excel/032 Higher than Previous Next.xlsx"
input = read_excel(path, range = "A1:B20")
test  = read_excel(path, range = "D1:D7")

result = input %>%
  filter(Temperature > lag(Temperature) & Temperature > lead(Temperature)) %>%
  select(`Answer Expected` = Date)

identical(result, test)
# [1] TRUE