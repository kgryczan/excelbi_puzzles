library(tidyverse)
library(readxl)

path = "Excel/700-799/715/715 - Alphabetic Triangle.xlsx"
input = 15
test = read_excel(path, range = "B2:P16", col_names = FALSE) %>% as.matrix()

make_letter_triangle_matrix <- function(n) {
  mat <- matrix(NA, n, n)
  idx <- which(lower.tri(mat, diag = TRUE), arr.ind = TRUE)
  mat[idx[order(idx[,1], idx[,2]), ]] <- rep(LETTERS, length.out = n * (n + 1) / 2)
  mat
}

result = make_letter_triangle_matrix(input)
all.equal(result, test, check.attributes = FALSE)
# [1] TRUE
