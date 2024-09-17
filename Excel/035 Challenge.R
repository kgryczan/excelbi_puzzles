library(tidyverse)
library(readxl)

path = "Excel/035 Pascal Triangle.xlsx"
test  = read_excel(path, range = "B1:T10", col_names = FALSE) %>% as.matrix()

pascal_triangle = matrix(0, nrow = 10, ncol = 19)

for (i in 1:1) {
  pascal_triangle[i, nrow(pascal_triangle) - i + 1] = 1
}
for (i in 2:10) {
  for (j in 2:18) {
    pascal_triangle[i, j] = pascal_triangle[i - 1, j - 1] + pascal_triangle[i - 1, j + 1]
  }
  pascal_triangle[i, 1] = pascal_triangle[i - 1, 2]
  pascal_triangle[i, 19] = pascal_triangle[i - 1, 18]
}
pascal_triangle[pascal_triangle == 0] = NA

all.equal(pascal_triangle, test, check.attributes = FALSE)
#> [1] TRUE