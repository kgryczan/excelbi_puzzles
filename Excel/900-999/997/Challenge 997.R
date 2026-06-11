library(tidyverse)
library(readxl)

path <- "900-999/997/997 Square Spiral.xlsx"
test <- read_excel(path, range = "B2:G7", col_names = FALSE) %>% as.matrix()

x <- c(LETTERS, 0:9)
idx <- matrix(1:36, 6, 6)
out <- character(36)

while (length(idx)) {
  n <- ncol(idx)
  out[idx[1, ]] <- x[seq_len(n)]
  x <- x[-seq_len(n)]
  idx <- idx[-1, , drop = FALSE]
  if (length(idx)) {
    idx <- t(idx)[ncol(idx):1, , drop = FALSE]
  }
}
result = matrix(out, 6, 6)
all.equal(result, test, check.attributes = FALSE)
# [1] TRUE
