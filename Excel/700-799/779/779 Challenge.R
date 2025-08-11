library(tidyverse)
library(readxl)

path = "Excel/700-799/779/779 Linked_in_Block_Shift.xlsx"
input = read_excel(path, range = "B2:F4", col_names = F) %>% as.matrix()
col_rotations = read_excel(path, range = "B1:F1", col_names = F) %>% as.numeric()
row_rotations = read_excel(path, range = "A2:A4", col_names = F) %>% pull()
test  = read_excel(path, range = "H2:L4", col_names = F) %>% as.matrix()


rotate_vec = function(vec, n) {
  n = n %% length(vec)
  c(tail(vec, n), head(vec, length(vec) - n))
}
apply_rotations = function(mat, row_rotations, col_rotations) {
  mat = map2(1:nrow(mat), row_rotations, ~ rotate_vec(mat[.x, ], .y)) %>%
    reduce(rbind)
  mat = map2(1:ncol(mat), col_rotations, ~ rotate_vec(mat[, .x], .y)) %>%
    reduce(cbind)
  mat
}
find_iteration = function(start_mat, target_mat, row_rotations, col_rotations, max_iter = 1000) {
  mat = start_mat
  for (i in 1:max_iter) {
    mat = apply_rotations(mat, row_rotations, col_rotations)
    if (all(mat == target_mat)) return(i)
  }
  NA
}

# find occuirrence of the test matrix in the iterations
result = find_iteration(input, test, row_rotations, col_rotations) # 32
result

# checking if after 50k iterations the result is the same as the test matrix
result_50000 = input
for (i in 1:50000) {
  result_50000 = apply_rotations(result_50000, row_rotations, col_rotations)
}
all.equal(result_50000, test, check.attributes = FALSE) # TRUE
# The result after 50000 iterations is the same as the test matrix