library(tidyverse)
library(readxl)

test2 = read_excel("Excel/372 Draw Inverted Right Angled Triangle.xlsx", range = "B2:C3", col_names = FALSE) %>%
  set_names(paste0("V", 1:ncol(.)))   
test3 = read_excel("Excel/372 Draw Inverted Right Angled Triangle.xlsx", range = "B5:D7", col_names = FALSE) %>%
  set_names(paste0("V", 1:ncol(.)))   
test4 = read_excel("Excel/372 Draw Inverted Right Angled Triangle.xlsx", range = "B9:E12", col_names = FALSE) %>%
  set_names(paste0("V", 1:ncol(.)))   
test7 = read_excel("Excel/372 Draw Inverted Right Angled Triangle.xlsx", range = "B14:H20", col_names = FALSE) %>%
  set_names(paste0("V", 1:ncol(.)))   


draw_inverted_triangle <- function(size) {
  numbers <- seq(size * (size + 1) / 2, 1)
  mat <- matrix(NA, nrow = size, ncol = size)
  
  mat[lower.tri(mat, diag = TRUE)] <- numbers
  mat <- apply(mat, 2, rev) %>% t()
  as_tibble(mat) %>% 
    print(n = Inf)
}

all.equal(draw_inverted_triangle(2), test2)
#> [1] TRUE

all.equal(draw_inverted_triangle(3), test3)
#> [1] TRUE

all.equal(draw_inverted_triangle(4), test4)
#> [1] TRUE

all.equal(draw_inverted_triangle(7), test7)
#> [1] TRUE
