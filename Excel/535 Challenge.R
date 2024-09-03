library(tidyverse)
library(readxl)

path = "Excel/535 Generate Number Grid.xlsx"
height = read_excel(path, range = "B1", col_names = F) %>% pull()
width = read_excel(path, range = "B2", col_names = F) %>% pull()

test = read_excel(path, range = "D2:K7", col_names = F) %>% as.matrix()

matrix = matrix(0, nrow = height, ncol = width)
for (i in 1:height) {
  matrix[i, ] <- c(tail(1:width, i - 1), head(1:width, width - (i - 1)))
}

all.equal(matrix, test, check.attributes = F)
# [1] TRUE