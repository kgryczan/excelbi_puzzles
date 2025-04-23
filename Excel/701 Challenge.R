library(tidyverse)
library(readxl)

path = "Excel/701 Swap Diagonals.xlsx"
input = read_excel(path, range = "A2:J11", col_names = FALSE) %>% as.matrix()
test = read_excel(path, range = "L2:U11", col_names = FALSE) %>% as.matrix()

d1 = diag(input)
d2 = diag(input[, ncol(input):1])

diag(input) <- d2
diag(input[, ncol(input):1]) <- d1

all(input == test) # [1] TRUE
