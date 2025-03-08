library(tidyverse)
library(readxl)

path = "Excel/668 Alphabetic Z.xlsx"

test3  = read_excel(path, range = "B2:D4", col_names = FALSE) %>% as.matrix()
test4  = read_excel(path, range = "B6:E9", col_names = FALSE) %>% as.matrix()
test6  = read_excel(path, range = "B11:G16", col_names = FALSE) %>% as.matrix()
test9  = read_excel(path, range = "B18:J26", col_names = FALSE) %>% as.matrix()
test12  = read_excel(path, range = "B28:M40", col_names = FALSE) %>% as.matrix()


draw_z = function(side) {
  L2 = rep(LETTERS, 2)
  M = matrix(NA, nrow =side , ncol = side)
  M[1,] = L2[1:side]
  M[cbind(1:side, side:1)] = L2[side:((2 * side) - 1)
  M[nrow(M),] = L2[((2*side)-1):((3*side)-2)]
  return(M)
}

all.equal(draw_z(3), test3, check.attributes = FALSE) # TRUE
all.equal(draw_z(4), test4, check.attributes = FALSE) # TRUE
all.equal(draw_z(6), test6, check.attributes = FALSE) # TRUE
all.equal(draw_z(9), test7, check.attributes = FALSE) # TRUE
all.equal(draw_z(12), test114, check.attributes = FALSE) # Different structure of Z

