library(tidyverse)
library(readxl)
library(matricks)

path = "Excel/673 Star Pattern.xlsx"
test3  = read_excel(path, range = "C3:E5", col_names = FALSE) %>% as.matrix()
test4  = read_excel(path, range = "C7:F10", col_names = FALSE) %>% as.matrix()
test7 = read_excel(path, range = "C12:I18", col_names = FALSE) %>% as.matrix()

make_star = function(side) {
  M = matrix(NA_character_, side, side)
  for (i in 1:side){
    M[i,i] = LETTERS[i]
    M[i,side+1-i] = LETTERS[i]
  } 
  return(M)
}

all.equal(make_star(3), test3, check.attributes = FALSE) # TRUE
all.equal(make_star(4), test4, check.attributes = FALSE) # TRUE
all.equal(make_star(7), test7, check.attributes = FALSE) # TRUE
