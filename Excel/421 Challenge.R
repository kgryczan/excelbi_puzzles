library(tidyverse)
library(readxl)

test1 = read_excel("Excel/421 Stack Diagonals.xlsx", range = "G2:H4", col_names = F)
test2 = read_excel("Excel/421 Stack Diagonals.xlsx", range = "G6:I10", col_names = F)
test3 = read_excel("Excel/421 Stack Diagonals.xlsx", range = "G12:J18", col_names = F)
test4 = read_excel("Excel/421 Stack Diagonals.xlsx", range = "G20:K28", col_names = F)

extract_antidiagonals = function(matrix_size) {
  dim = sqrt(matrix_size)
  
  M = matrix(1:matrix_size, nrow=dim, ncol=dim)
  d = row(M)+col(M)
  x = split(M, d) 
  x = lapply(x, rev) %>%
    lapply(function(x) c(x, rep(NA, nrow(M) - length(x))) )
  
  N = matrix(nrow = length(x), ncol = ncol(M)) %>%
    as.data.frame()
  
  for (i in 1:length(x)) {
    N[i,] = x[[i]]
  }
  
  N = as_tibble(N)
  
  return(N)
}

extract_antidiagonals(4) == test1
extract_antidiagonals(9) == test2
extract_antidiagonals(16) == test3
extract_antidiagonals(25) == test4

extract_antidiagonals(4)
extract_antidiagonals(9)
extract_antidiagonals(16)
extract_antidiagonals(25)

