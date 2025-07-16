library(tidyverse)
library(readxl)

input = read_excel("Reverse Rows.xlsx", range = "A1:E19")
test = read_excel("Reverse Rows.xlsx", range = "G1:K19")

mat <- as.matrix(input)

reverse_align_values <- function(row) {
  row_no_na <- row[!is.na(row)]
  row_reversed <- rev(row_no_na)
  result <- c(row_reversed, rep(NA, length(row) - length(row_no_na)))
  return(result)
}

mat <- t(apply(mat, 1, reverse_align_values))

result <- as.tibble(mat)
colnames(result) <- colnames(test)