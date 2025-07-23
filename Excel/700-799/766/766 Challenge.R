library(tidyverse)
library(readxl)
library(matricks)

path = "Excel/700-799/766/766 Swap Diagonals.xlsx"
input = read_excel(path, range = "A2:J11", col_names = FALSE) %>% as.matrix()
test  = read_excel(path, range = "L2:U11", col_names = FALSE) %>% as.matrix()

swap_diagonals = function(mat) {
  n = nrow(mat)
  mat[cbind(1:n, 1:n)] = rev(mat[cbind(1:n, 1:n)])
  mat[cbind(1:n, n:1)] = rev(mat[cbind(1:n, n:1)])
  return(mat)
}

result = swap_diagonals(input)
all.equal(result, test)
#> [1] TRUE