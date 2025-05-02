library(tidyverse)
library(readxl)

path = "Excel/033 Generate Seq.xlsx"
test  = read_excel(path, range = "A1:Z26", col_names = F) %>%
  as.matrix()

M = matrix(NA, nrow = 26, ncol = 26)
for (i in 1:26) {
  for (j in 1:i) {
    M[i, j] = paste(LETTERS[i], str_pad(as.character(j), 2, pad = "0", side = "left"), sep = "-")
  }
}

all.equal(test, M, check.attributes = F)
#> [1] TRUE