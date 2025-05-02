library(tidyverse)
library(readxl)

path = "Excel/577 Make ASCII Lamp.xlsx"
test  = read_excel(path, range = "B2:X11", col_names = F)  %>% as.matrix()
test[is.na(test)] <- ""

centered = function(matrix, row, how_many) {
  pad <- (ncol(matrix) - how_many) %/% 2
  matrix[row, ] <- c(rep("", pad), rep("x", how_many), rep("", ncol(matrix) - how_many - pad))
  matrix
}

M = matrix("", nrow = 10, ncol = 23)

M <- reduce(2:3, ~centered(.x, .y, 1), .init = M)
M <- reduce(4:6, ~centered(.x, .y, 3), .init = M)
M <- reduce(7:10, ~centered(.x, .y, 21 - (.y - 7) * 2), .init = M)

all.equal(M, test, check.attributes = F)
#> [1] TRUE