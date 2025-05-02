library(tidyverse)
library(readxl)

path = "Excel/602 Clarks Triangle.xlsx"
test  = read_excel(path, range = "A2:U12", col_names = F) %>% as.matrix() %>% replace(is.na(.), 0)

create_clarks_matrix = function(n) {
  mat = matrix(0, nrow = n, ncol = n * 2 - 1)
  mid = n
  for (i in 1:n) {
    for (j in 1:(n * 2 - 1)) {
      if (j == mid - (i - 1)) {
        mat[i, j] = ifelse(i == 1, 0, 1)
      } else if (j == mid + (i - 1)) {
        mat[i, j] = 6 * (i - 1)
      } else if (i > 1 && j > 1 && j < n * 2 - 1 && mat[i - 1, j - 1] != 0 && mat[i - 1, j + 1] != 0) {
        mat[i, j] = mat[i - 1, j - 1] + mat[i - 1, j + 1]
      }
    }
  }
  return(mat)
}

n = 11
clark = create_clarks_matrix(n)

all.equal(clark, test, check.attributes = F)
# [1] TRUE                                                                          