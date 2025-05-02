library(tidyverse)
library(readxl)

test2 = read_excel("Excel/448 Draw Inverted Triangle.xlsx", range = "B2:D3", col_names = FALSE) %>%
  as.matrix()
test3 = read_excel("Excel/448 Draw Inverted Triangle.xlsx", range = "B5:F7", col_names = FALSE) %>%
  as.matrix()
test4 = read_excel("Excel/448 Draw Inverted Triangle.xlsx", range = "B9:H12", col_names = FALSE) %>%
  as.matrix()
test7 = read_excel("Excel/448 Draw Inverted Triangle.xlsx", range = "B14:N20", col_names = FALSE) %>%
  as.matrix()

create_sequence_matrix <- function(n) {
  total_elements <- n * (n + 1) / 2 
  max_elements_in_row <- n  
  values <- seq(total_elements)
  mat <- matrix(NA, nrow = n, ncol = max_elements_in_row)
  start_index <- 1
  for (i in 1:n) {
    end_index <- start_index + i - 1
    mat[i, 1:i] <- values[start_index:end_index]
    start_index <- end_index + 1
  }
  mat
}

flip_horizontal <- function(mat) {
  mat[, ncol(mat):1, drop = FALSE]
}

flip_vertical <- function(mat) {
  mat[nrow(mat):1, , drop = FALSE]
}

generate_upsidedown_triangle = function(n) {

mat_or = create_sequence_matrix(n)
mat_fh = flip_horizontal(mat_or)
mat_fv1 = flip_vertical(mat_or)
mat_fv2 = flip_vertical(mat_fh)
mat_fv2 <- mat_fv2[, -ncol(mat_fv2)]
mat_fin <- cbind(mat_fv2, mat_fv1)

mat_fin
}

all.equal(generate_upsidedown_triangle(2), test2, check.attributes = FALSE) # TRUE
all.equal(generate_upsidedown_triangle(3), test3, check.attributes = FALSE) # TRUE
all.equal(generate_upsidedown_triangle(4), test4, check.attributes = FALSE) # TRUE
all.equal(generate_upsidedown_triangle(7), test7, check.attributes = FALSE) # TRUE



