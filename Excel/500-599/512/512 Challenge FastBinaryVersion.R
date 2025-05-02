library(tidyverse)
library(readxl)

path = "Excel/512 Next Sparse Number.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10")

next_sparse_number_fast <- function(n) {
  repeat {
    m <- n
    k <- 0
    change_required <- FALSE

    while (m > 0) {
      if ((m %% 4) == 3) {
        change_required <- TRUE
        break
      }
      m <- m %/% 2
      k <- k + 1
    }
    
    if (!change_required) break
    
    n <- (n %/% (2^(k + 1))) * (2^(k + 1)) + (2^(k + 1))
  }
  return(n)
}


result = input %>%
  mutate(`Answer Expected` = map_dbl(Number, next_sparse_number_fast))

identical(result$`Answer Expected`, test$`Answer Expected`)
#> [1] TRUE