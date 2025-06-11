library(tidyverse)
library(readxl)

path = "Excel/700-799/736/736 Word Square Missing Entries.xlsx"
read_as_matrix <- function(range) {
  read_excel(path, range = range, col_names = FALSE) %>% as.matrix()
}

input1 = read_as_matrix("B2:C3")
input2 = read_as_matrix("B5:D7")
input3 = read_as_matrix("B9:E12")
input4 = read_as_matrix("B14:F18")
input5 = read_as_matrix("B20:G25")
test1 = read_as_matrix("I2:J3")
test2 = read_as_matrix("I5:K7")
test3 = read_as_matrix("I9:L12")
test4 = read_as_matrix("I14:M18")
test5 = read_as_matrix("I20:N25")

fill_matrix <- function(mat) {
  na_idx <- which(is.na(mat), arr.ind = TRUE)
  mat[na_idx] <- mat[na_idx[,2:1]]
  mat
}

all.equal(fill_matrix(input1), test1)
all.equal(fill_matrix(input2), test2)
all.equal(fill_matrix(input3), test3)
all.equal(fill_matrix(input4), test4)
all.equal(fill_matrix(input5), test5)
