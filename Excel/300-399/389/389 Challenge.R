library(tidyverse)
library(readxl)

number = read_excel("Excel/389 Quadrant.xlsx", range = "A1", col_names = FALSE) %>% pull()

test = read_excel("Excel/389 Quadrant.xlsx", range = "A2:I10", col_names = FALSE) %>%
  as.data.frame()
colnames(test) = c(as.character(1:ncol(test)))

generate_cross = function(size) {
  full_size = 2*size+1
  center = size+1
  mat = matrix(NA, full_size, full_size)
  seq = seq(size, -size)
  rev_seq = rev(seq)
  mat[center,] <- rev_seq
  mat[,center] <- seq
  mat = as.data.frame(mat)
  colnames(mat) = c(as.character(1:ncol(mat)))
  return(mat)
}

result = generate_cross(number) 

all.equal(test, result)
# [1] TRUE

