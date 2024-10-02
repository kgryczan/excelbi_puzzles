library(tidyverse)
library(readxl)

path = "Excel/556 Generate Triangle Cumsum.xlsx"
input = read_excel(path, range = "A1:A1", col_names = FALSE) %>% pull()
test  = read_excel(path, range = "B2:T11:", col_names = FALSE) %>% as.matrix()

M = matrix(NA_real_, nrow = input, ncol = 2 * input - 1)
p = 1:input %>% cumsum()

for (i in 1:10) {
  M[i, (input - i + 1):(input + i - 1)] = rev(p)[i]  
}

all.equal(M, test, check.attributes = FALSE) # TRUE
