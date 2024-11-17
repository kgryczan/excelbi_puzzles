library(tidyverse)
library(readxl)

path = "Excel/166 Porta Chipher Grid.xlsx"
test  = read_excel(path, range = "A2:M14", col_names = FALSE) %>% as.matrix()

letters_seq = LETTERS[14:26]


M = matrix(NA, nrow = 13, ncol = 13)
for (i in 1:13) {
  M[i, ] <- c(tail(letters_seq, i - 1), head(letters_seq, 13 - (i - 1)))
}

all(test == M)
#> [1] TRUE