library(tidyverse)
library(readxl)

path = "Excel/491 Draw A Hollow Half Pyramid.xlsx"

test5 = read_excel(path, range = "C1:G6") %>% as.matrix()
test8 = read_excel(path, range = "C8:J16") %>% as.matrix()

draw_halfpyramid = function(input) {
  matrix = matrix(NA, nrow = input, ncol = input)  
  for (i in 1:input) {
    matrix[i, 1] = 1
    matrix[i, i] = i
    matrix[input, i] = i
  }
  return(matrix)
}

all.equal(draw_halfpyramid(5), test5, check.attributes = FALSE) # TRUE
all.equal(draw_halfpyramid(8), test8, check.attributes = FALSE) # TRUE