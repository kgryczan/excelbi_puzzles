library(tidyverse)
library(readxl)

path = "Excel/230 Snake Grid.xlsx"
count = 56
cols = 6
test = read_excel(path, range = "A4:F13", col_names = FALSE) %>% as.matrix()

rows = ceiling(count / cols)
M = matrix(0, nrow = rows, ncol = cols)

seq = 1:count
seq = matrix(c(seq, rep(NA, rows * cols - count)), nrow = rows, byrow = TRUE)

seq[seq(2, nrow(seq), by = 2), ] = t(apply(seq[seq(2, nrow(seq), by = 2), ], 1, rev))

M = seq

M == test
