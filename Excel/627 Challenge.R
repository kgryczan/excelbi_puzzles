library(tidyverse)
library(readxl)

path = "Excel/627 Alphabets Staircase_2.xlsx"
test = read_excel(path, range = "A2:BA53", col_names = F)

al = LETTERS
M = matrix(NA , nrow = 52,  ncol = 53)

for (i in 1:26) {
  indices = list(c(2*i - 1, 2*i - 1 ), c(2*i - 1, 2*i), c(2*i - 1, 2*i + 1), c(2*i, 2*i + 1))
  for (index in indices) {
    M[index[1], index[2]] = al[i]
  }
}

M = as.data.frame(M)
names(test) = names(M)

all(M == test, na.rm = T)
# [1] TRUE