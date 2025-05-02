library(tidyverse)
library(readxl)

path = "Excel/058 UnCommon in All Columns.xlsx"
input = read_excel(path, range = "A1:C12")
test  = read_excel(path, range = "D1:D9") %>% pull()

a1 = input$Animals1
a2 = input$Animals2
a3 = input$Animals3

d1 = setdiff(a1, c(a2, a3))
d2 = setdiff(a2, c(a1, a3))
d3 = setdiff(a3, c(a1, a2))

all(test == c(d1, d2, d3))
#> [1] TRUE