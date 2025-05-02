library(tidyverse)
library(readxl)

path = "Excel/118 Binary to Decimal.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10")

result = input %>%
  mutate(sign = str_sub(Binary, 1,1),
         number = str_sub(Binary, 2, nchar(Binary))) %>%
  mutate(Decimal = strtoi(number,base = 2) * ifelse(sign == "1", -1, 1)) 

all.equal(result$Decimal, test$Decimal)
#> [1] TRUE