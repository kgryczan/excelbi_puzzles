library(tidyverse)
library(readxl)

path = "Excel/597 Pentagram.xlsx"
test  = read_excel(path, range = "C3:U15", col_names = FALSE) %>% as.matrix()

M = matrix(NA, nrow = 13, ncol = 19)
middle = (ncol(M) + 1) / 2

draw_x_pattern <- function(M, middle) {
  M[1, middle] = "x"
  for (i in 2:nrow(M)) {
    if (middle - i >= 0) {
      M[i, middle + i - 1] = "x"
      M[i, middle - i + 1] = "x"
    }
  }
  M
}

M = draw_x_pattern(M, middle)         
M = M[nrow(M):1,]
M = draw_x_pattern(M, middle)

rows = which(!is.na(M[, 1]))

for (i in rows) {
  M[i, ] = "x"
}

all.equal(M, test, check.attributes = FALSE)
#> [1] TRUE
