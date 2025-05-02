library(tidyverse)
library(readxl)

test1 = read_excel("Excel/380 Draw NxN Squares.xlsx", range = "A2:H9",   col_names = FALSE) %>%
  as.matrix() %>% {attr(., "dimnames") <- NULL; .}
test2 = read_excel("Excel/380 Draw NxN Squares.xlsx", range = "A11:G17", col_names = FALSE) %>%
  as.matrix() %>% {attr(., "dimnames") <- NULL; .}
test3 = read_excel("Excel/380 Draw NxN Squares.xlsx", range = "A19:E23", col_names = FALSE) %>%
  as.matrix() %>% {attr(., "dimnames") <- NULL; .}
test4 = read_excel("Excel/380 Draw NxN Squares.xlsx", range = "A25:D28", col_names = FALSE) %>%
  as.matrix() %>% {attr(., "dimnames") <- NULL; .}

draw_sides_and_diag = function(matrix_size) {
  mat = matrix(NA, nrow = matrix_size, ncol = matrix_size)
  mat[1,] = "x"
  mat[matrix_size,] = "x"
  mat[,1] = "x"
  mat[,matrix_size] = "x"
  diag(mat) = "x"
  diag(mat[,ncol(mat):1]) = "x"

  return(mat)
}

all.equal(draw_sides_and_diag(8), test1)
#> [1] TRUE
all.equal(draw_sides_and_diag(7), test2)
#> [1] TRUE
all.equal(draw_sides_and_diag(5), test3)
#> [1] TRUE
all.equal(draw_sides_and_diag(4), test4)
#> [1] TRUE


draw_sides_and_diag(8)

