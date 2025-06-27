library(tidyverse)
library(readxl)

path = "Excel/700-799/748/748 Diamond.xlsx"
test  = read_excel(path, range = "B2:R18", col_names = FALSE) %>% as.matrix()

n = 9
s = 2*n - 1
m = outer(1:s, 
           1:s, 
           function(i, j) ifelse((d = abs(i - n) + abs(j - n)) < n, n - d, NA_integer_))

all(m == test, na.rm = TRUE)
# > [1] TRUE