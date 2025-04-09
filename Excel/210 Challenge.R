library(tidyverse)
library(readxl)

path = "Excel/210 Triangle of Odd Numbers.xlsx"
input = 5
test  = read_excel(path, range = "A3:I7", col_names = FALSE) %>%
  as.matrix() %>%
  replace(is.na(.), "") 

triangle_odd_matrix <- function(layers) {
  total_numbers <- layers * (layers + 1) / 2
  odd_numbers <- seq(1, by = 2, length.out = total_numbers)
  triangle_mat <- matrix("", nrow = layers, ncol = 2 * layers - 1)
  idx <- 1
  for (i in 1:layers) {
    positions <- seq(from = layers - i + 1, by = 2, length.out = i)
    triangle_mat[i, positions] <- as.character(odd_numbers[idx:(idx + i - 1)])
    idx <- idx + i
  }
  return(triangle_mat)
}

all.equal(triangle_odd_matrix(5),test, check.attributes = FALSE) 
# TRUE