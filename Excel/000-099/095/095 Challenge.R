library(tidyverse)
library(readxl)

path = "Excel/095 Grid Find.xlsx"
input = read_excel(path, range = "B2:M10", col_names = FALSE) %>% as.matrix()
lookup = read_excel(path, range = "O2:O4", col_names = FALSE) %>% pull()
test  = 3

result = sum(apply(input, 1, function(x) all(lookup %in% x)))

all.equal(result, test)
#> [1] TRUE