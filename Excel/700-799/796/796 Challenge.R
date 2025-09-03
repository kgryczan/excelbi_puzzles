library(tidyverse)
library(readxl)

path = "Excel/700-799/796/796 Pattern Drawing.xlsx"
test  = read_excel(path, range = "B2:R18", col_names = FALSE) %>%
  as.matrix()

bowtie_matrix = function(n) {
  rows = 2 * n - 1
  cols = 2 * n - 1
  mat = matrix(NA, nrow = rows, ncol = cols)
  
  for (r in 1:rows) {
    k = if (r <= n) r else 2 * n - r
    left_vals = k:1
    mat[r, 1:k] = left_vals
    right_vals = 1:k
    mat[r, (cols - k + 1):cols] = right_vals
  }
  mat
}

result = bowtie_matrix(9)
all.equal(test, result, check.attributes = FALSE)
# TRUE