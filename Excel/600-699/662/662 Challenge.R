library(tidyverse)
library(readxl)

path = "Excel/662 Create a Pyramid.xlsx"
test6  = read_excel(path, range = "C2:N7", col_names = F) %>% as.matrix() %>% replace(., is.na(.), " ")

draw_pyramid <- function(stores) {
  M <- matrix(" ", nrow = stores, ncol = stores * 2)
  for (i in 1:stores) {
    M[i, ] <- strsplit(paste(c(rep(" ", stores - i), "/", rep("/\\", i - 1), "\\", rep(" ", stores - i)), collapse = ""), "")[[1]]
  }
  return(M)
}

a = draw_pyramid(6)

all(a == test6)
#> [1] TRUE