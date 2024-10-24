library(tidyverse)
library(readxl)

path = "Excel/148 Rotate Rows.xlsx"
input = read_excel(path, range = "B1", col_names = F) %>% pull()
input2 = read_excel(path, range = "A4:E7", col_names = F) %>% as.matrix()
test  = read_excel(path, range = "G4:K7", col_names = F) %>% as.matrix()

# function to rotate rows in matrix
# size of shift/rotation is in input

rotate_rows = function(input, matrix){
  n = nrow(matrix)
  m = ncol(matrix)
  shift = input %% n
  matrix[c((n - shift + 1):n, 1:(n - shift)), ]
}
  
output = rotate_rows(input, input2)

all.equal(output, test)
#> [1] TRUE