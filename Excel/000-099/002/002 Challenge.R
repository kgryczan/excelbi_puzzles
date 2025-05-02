library(tidyverse)
library(readxl)

path = "Excel/002 Last 3 Non Zero Sum.xlsx"
input = read_excel(path, range = "A1:A10")
test = 44

result = sum(tail(input$Data[input$Data != 0],3))

result == test
# [1] TRUE