library(tidyverse)
library(readxl)

path = "Excel/677 Generate the Pattern.xlsx"
test  = read_excel(path, range = "B2:R10", col_names = FALSE) %>% as.matrix() %>% replace(is.na(.), "")

M = matrix("", 9, 17)

generate_sequence <- function(X) {
  if (X == 1) return(1)
  c(seq(X, 1, by = -1), seq(2, X, by = 1))
}

for (i in 1:9) {
  seq_i <- generate_sequence(i)
  M[i, 1:length(seq_i)] <- seq_i
}

all.equal(M, test, check.attributes = FALSE)
#> [1] TRUE