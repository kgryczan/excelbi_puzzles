library(tidyverse)
library(readxl)
library(matricks)

path = "Excel/700-799/784/784 Sum of Square.xlsx"
input = read_excel(path, range = "B2:K11", col_names = FALSE) %>% as.matrix()
test  = read_excel(path, range = "M1:M2") %>% pull()

result = sum(rowSums(input)) + sum(colSums(input)) + sum(diag(input)) + sum(antidiag(input))

result == test 
# > [1] TRUE