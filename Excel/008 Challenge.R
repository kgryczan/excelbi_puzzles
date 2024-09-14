library(tidyverse)
library(readxl)

path = "Excel/008 Last Value Lookup.xlsx"

input = read_excel(path, range = "A1:B10")
test1 = 802 # if miami chosen as city

city = "Miami"

result = input %>% filter(City == city) %>% tail(1) %>% pull(Sales)

result == test1
# [1] TRUE