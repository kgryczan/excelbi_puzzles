library(tidyverse)
library(readxl)

path = "Excel/800-899/841/841 Sum of Alternate Signs Series.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10") %>% pull()

agg = function(n) if(n %% 2 == 0) n / 2 + 2 else (3 - n) / 2
result = map_dbl(input$N, agg)

all.equal(result, test)
# [1] TRUE