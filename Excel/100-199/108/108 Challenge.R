library(tidyverse)
library(readxl)

path = "Excel/108 Reverse Rows Columns.xlsx"
input = read_excel(path, range = "A2:E5", col_names = FALSE) %>% as.matrix()
test  = read_excel(path, range = "G2:K5", col_names = FALSE) %>% as.matrix()

result = input[nrow(input):1, ncol(input):1]

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE