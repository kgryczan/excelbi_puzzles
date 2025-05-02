library(tidyverse)
library(readxl)

path = "Excel/533 ASCII Star.xlsx"
test5 = read_excel(path, range = "F3:J7", col_names = FALSE) 
test7 = read_excel(path, range = "E9:K15", col_names = FALSE)
test9 = read_excel(path, range = "D17:L25", col_names = FALSE)
test11 = read_excel(path, range = "C27:M37", col_names = FALSE)

draw_ascii_star  = function(number) {
  matrix = matrix(NA, nrow = number, ncol = number)
  for (i in 1:number) {
    matrix[i, number %/% 2 + 1] = "*"
    matrix[number %/% 2 + 1, i] = "*"
    matrix[i, i] = "*"
    matrix[i, number - i + 1] = "*"
  }
  result = as.data.frame(matrix)
  colnames(result) = NULL
  rownames(result) = NULL
  return(result)
}

a5 = draw_ascii_star(5)
all.equal(a5, test5, check.attributes = FALSE) # TRUE

a7 = draw_ascii_star(7)
all.equal(a7, test7, check.attributes = FALSE) # TRUE

a9 = draw_ascii_star(9)
all.equal(a9, test9, check.attributes = FALSE) # TRUE

a11 = draw_ascii_star(11)
all.equal(a11, test11, check.attributes = FALSE) # TRUE