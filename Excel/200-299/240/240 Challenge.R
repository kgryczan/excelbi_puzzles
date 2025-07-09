library(tidyverse)
library(readxl)

path = "Excel/200-299/240/240 Rotate Rows Columns.xlsx"
input1 = read_excel(path, range = "B1:B1", col_names = FALSE) %>% pull()
input2 = read_excel(path, range = "B2:B2", col_names = FALSE) %>% pull()
input3 = read_excel(path, range = "A4:E7", col_names = FALSE) %>% as.matrix()
test  = read_excel(path, range = "G4:K7", col_names = FALSE) %>% as.matrix()

rotate_matrix = function(shift, matrix, axis = c("row", "col")) {
  axis = match.arg(axis)
  if (axis == "row") {
    n = nrow(matrix)
    shift = shift %% n
    matrix[c((n - shift + 1):n, 1:(n - shift)), ]
  } else {
    m = ncol(matrix)
    shift = shift %% m
    matrix[, c((m - shift + 1):m, 1:(m - shift))]
  }
}

result = rotate_matrix(input1, input3, "row") %>% 
  rotate_matrix(input2, ., "col")


all(result == test) 
# > [1] TRUE