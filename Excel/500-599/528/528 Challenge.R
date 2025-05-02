library(tidyverse)
library(readxl)

path = "Excel/528 Diamonds of Alphabets.xlsx"

draw_diamond = function(size) {
  M = matrix(NA, nrow = 2 * size - 1, ncol = 2 * size - 1)

  for (i in 1:(2 * size - 1)) {
    for (j in 1:(2 * size - 1)) {
      M[i, j] = abs(abs(i - size) + abs(j - size)) + 1
    }
  }
  M = M %>% as.data.frame() %>% mutate_all(~ifelse(. <= size, LETTERS[.], ""))
  return(M)
}

draw_diamond(3)
draw_diamond(5)
draw_diamond(8)
