library(tidyverse)
library(readxl)

path = "Excel/200-299/260/260 Alphabets Grid.xlsx"
input = read_excel(path, range = "A1:A1", col_names = FALSE) %>% pull()
test  = read_excel(path, range = "A2:G8", col_names = FALSE) %>% 
  replace(is.na(.), "") %>%
  as.matrix()

make_staircase_matrix = function(n) {
  mat = matrix("", n, n)
  for (i in 1:n) {
    mat[i, i:n] = LETTERS[1:(n - i + 1)]
  }
  mat
}

all.equal(test, make_staircase_matrix(7), check.attributes = FALSE) 
#> TRUE