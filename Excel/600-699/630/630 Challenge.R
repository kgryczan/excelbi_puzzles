library(tidyverse)
library(readxl)

path = "Excel/630 Immediate Last Caller.xlsx"
input = read_excel(path, range = "A1:C16")
test  = read_excel(path, range = "D1:D16")

result = input %>% 
  mutate(`Answer Expected` = order_by(Time, lag(Caller)), .by = Date) 

all.equal(result$`Answer Expected`, test$`Answer Expected`)
# [1] TRUE
