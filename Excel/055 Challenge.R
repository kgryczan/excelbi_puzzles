library(tidyverse)
library(readxl)

path = "Excel/055 Number Grid.xlsx"
test  = read_excel(path, range = "A2:J11", col_names = FALSE) %>% as.matrix()

M = matrix(0, nrow = 10, ncol = 10)
for (i in 1:10) {
  for (j in 1:10) {
    M[i, j] = sum(as.numeric(strsplit(as.character(i*j), "")[[1]]))
  }
}

all.equal(M, test, check.attributes = FALSE)
#> [1] TRUE