library(tidyverse)
library(readxl)

path = "Excel/553 ASCII Abacus.xlsx"
test  = read_excel(path, range = "B2:T13", col_names = FALSE) %>% as.matrix()

M = matrix(NA_character_, nrow = 12, ncol = 19)

for (i in 1:12) {
  for (j in 1:19) {
    if (i %in% c(1, 5, 12)) {
      M[i, j] = "---"
    } else if (i %in% c(2, 6)) {
      M[i, j] = "|"
    } else {
      M[i, j] = "O"
    }
  }
}

for (i in 2:11) {
  M[i, 1] = "|"
  M[i, 19] = "|"
}

all(M == test) %>% print()
as.data.frame(M)
