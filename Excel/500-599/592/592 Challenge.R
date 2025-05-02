library(tidyverse)
library(readxl)

path = "Excel/592 Bell Triangle.xlsx"
input = read_excel(path, range = "B2:B2", col_names = F) %>% pull()
test_10  = read_excel(path, range = "A4:J13", col_names = F) %>% as.matrix()

M = matrix(NA_integer_, nrow = input, ncol = input)

M[1, 1] = 1

for (i in 2:input) {
  M[i, 1] = M[i - 1, i-1]
  for(j in 2:i) {
    M[i, j] = M[i, j - 1] + M[i - 1, j - 1]
  }
}

all.equal(M, test_10, check.attributes = F)
# > [1] TRUE