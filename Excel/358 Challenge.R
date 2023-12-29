library(tidyverse)
library(readxl)

input_1 = read_excel("Excel/358 Stack Diagonal Values.xlsx", 
                     range = "A2:C4", col_names = F) %>%  as.matrix()
input_2 = read_excel("Excel/358 Stack Diagonal Values.xlsx", 
                     range = "A6:D9",  col_names = F) %>% as.matrix()
input_3 = read_excel("Excel/358 Stack Diagonal Values.xlsx", 
                     range = "A11:E15", col_names = F) %>% as.matrix()

test_1 = read_excel("Excel/358 Stack Diagonal Values.xlsx", 
                    range = "G2:H4", col_names = c("A", "B"))
test_2 = read_excel("Excel/358 Stack Diagonal Values.xlsx", 
                    range = "G6:H9", col_names = c("A", "B"))
test_3 = read_excel("Excel/358 Stack Diagonal Values.xlsx", 
                    range = "G11:H15", col_names = c("A", "B"))

get_diagonals = function(M) {
  result = tibble(
    A = diag(M),
    B = diag(M[, ncol(M):1])
  )
  return(result)
}

identical(test_1, get_diagonals(input_1))
#> [1] TRUE
identical(test_2, get_diagonals(input_2))
#> [1] TRUE
identical(test_3, get_diagonals(input_3))
#> [1] TRUE

