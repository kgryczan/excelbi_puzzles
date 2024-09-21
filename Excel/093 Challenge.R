library(tidyverse)
library(readxl)

path = "Excel/093 Triangle Draw.xlsx"
test5  = read_excel(path, range = "A2:E6", col_names = FALSE) %>% as.matrix()

draw_triangle = function(size) {
    M = matrix(NA, nrow = size, ncol = size)
    for (i in 1:size) {
      M[i, 1:(size-i+1)] <- "*"
    }
    return(M)
  }

all.equal(draw_triangle(5), test5, check.attributes = FALSE)
#> [1] TRUE