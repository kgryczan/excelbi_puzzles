library(tidyverse)
library(readxl)

path = "Excel/532 Grid where each is sum of already filled in surrounding cells.xlsx"
test  = read_excel(path, range = "B2:K11", col_names = FALSE) %>% as.matrix()

matrix_size <- 10
m <- matrix(0, nrow = matrix_size, ncol = matrix_size)
m[1, 1] <- 1

for (i in 1:matrix_size) {
  for (j in 1:matrix_size) {
    if (i != 1 || j != 1) {
      m[i, j] <- sum(m[pmax(i - 1, 1):pmin(i + 1, matrix_size),
                       pmax(j - 1, 1):pmin(j + 1, matrix_size)])
    }
  }
}

all.equal(m, test, check.attributes = FALSE) # TRUE
