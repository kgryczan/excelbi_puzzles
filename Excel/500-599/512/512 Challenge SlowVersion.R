library(tidyverse)
library(readxl)

path = "Excel/512 Next Sparse Number.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10")


next_sparse_number_slow <- function(n) {
  is_sparse <- function(n) {
    binary_n <- intToBits(n)
    for (i in 2:length(binary_n)) {
      if (binary_n[i] == 1 && binary_n[i - 1] == 1) {
        return(FALSE)
      }
    }
    return(TRUE)
  }
  detect((n + 1):(2 * n + 1), is_sparse)
}

result = input %>%
  mutate(`Answer Expected` = map_dbl(Number, next_sparse_number_slow))

# compute slow for last two numbers, so I break computing
# for first 7 numbers works smoothly and correctly