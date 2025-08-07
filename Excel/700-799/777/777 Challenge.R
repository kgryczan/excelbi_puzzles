library(tidyverse)
library(readxl)

path = "Excel/700-799/777/777 Reverse Flyod Triangle.xlsx"
input1 = read_excel(path, range = "A2:A2", col_names = FALSE) %>% pull()
input2 = read_excel(path, range = "A5:A5", col_names = FALSE) %>% pull()
input3 = read_excel(path, range = "A9:A9", col_names = FALSE) %>% pull()
test1  = read_excel(path, range = "C2:D3", col_names = FALSE) %>% as.matrix()
test2  = read_excel(path, range = "C5:E7", col_names = FALSE) %>% as.matrix()
test3  = read_excel(path, range = "C9:L18", col_names = FALSE) %>% as.matrix()

tri_matrix = function(n) {
  M = matrix(NA, n, n)
  for (i in seq_len(n)) {
    M[i, 1:i] = rev(seq_len(i) + i * (i - 1) / 2)
  }
  M
}

all.equal(tri_matrix(input1), test1, check.attributes = FALSE) # TRUE
all.equal(tri_matrix(input2), test2, check.attributes = FALSE) # TRUE
all.equal(tri_matrix(input3), test3, check.attributes = FALSE) # TRUE
