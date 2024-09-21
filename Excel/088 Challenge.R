library(tidyverse)
library(readxl)

path = "Excel/088 Tabula Recta.xlsx"
test  = read_excel(path, range = "B1:AA27") %>% as.matrix()

M = matrix(0, nrow = 26, ncol = 26)

for (i in 1:26) {
  M[i,] = LETTERS[(1:26 + i - 2) %% 26 + 1]
}
M

all.equal(M, test, check.attributes = FALSE)
#> [1] TRUE