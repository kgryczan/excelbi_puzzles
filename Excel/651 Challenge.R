library(tidyverse)
library(readxl)

path = "Excel/651 Vortex Sequence.xlsx"
test2 = read_excel(path, range = "B2:C3", col_names = F) %>% as.matrix()
test4 = read_excel(path, range = "B6:E9", col_names = F) %>% as.matrix()
test7 = read_excel(path, range = "B12:H18", col_names = F) %>% as.matrix()

spiral_matrix <- function(n) {
  m <- matrix(0, n, n)
  directions <- list(c(-1, 0), c(0, 1), c(1, 0), c(0, -1))
  dir_idx <- 1
  pos <- c(n, 1)
  
  for (i in 1:(n * n)) {
    m[pos[1], pos[2]] <- i
    next_pos <- pos + directions[[dir_idx]]
    
    if (!(all(next_pos >= 1 & next_pos <= n) && m[next_pos[1], next_pos[2]] == 0)) {
      dir_idx <- (dir_idx %% 4) + 1
      next_pos <- pos + directions[[dir_idx]]
    }
    pos <- next_pos
  }
  m
}

all.equal(spiral_matrix(2), test2, check.attributes = F) # TRUE
all.equal(spiral_matrix(4), test4, check.attributes = F) # TRUE
all.equal(spiral_matrix(7), test7, check.attributes = F) # TRUE
