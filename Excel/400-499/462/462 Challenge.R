library(tidyverse)
library(readxl)

input = read_excel("Excel/462 Fill in the Grid.xlsx", range = "A2:J11", col_names = F) %>%
  as.matrix()
test  = read_excel("Excel/462 Fill in the Grid.xlsx", range = "A14:J23", col_names = F) %>%
  as.matrix()

na_coords = which(is.na(input), arr.ind = T) 

get_surrounding_values = function(x, y, matrix){
  values = c()
  for (i in -1:1) {
    for (j in -1:1) {
      if (x + i > 0 & x + i <= nrow(matrix) & y + j > 0 & y + j <= ncol(matrix)) {
        values = c(values, matrix[x + i, y + j])
      }
    }
  }
  return(max(values, na.rm = T))
}


for (i in 1:nrow(na_coords)) {
  input[na_coords[i, 1], na_coords[i, 2]] = get_surrounding_values(na_coords[i, 1], na_coords[i, 2], input)
}

identical(input, test)
#> [1] TRUE