library(tidyverse)
library(readxl)

path = "Excel/501 Find Consecutives in Grid.xlsx"
input = read_excel(path, range = "B2:M10", col_names = FALSE) 
test  = read_excel(path, range = "O1:O6")

i1 = as.matrix(input)
i2 = t(i1)

find_repeats_in_rows <- function(matrix) {
  unique(unlist(apply(matrix, 1, function(row) {
    row[which(diff(row) == 0)]
  })))
}

result = union(find_repeats_in_rows(i1),
               find_repeats_in_rows(i2)) %>%
  sort() %>%
  as_tibble() %>%
  setNames("Answer Expected")

identical(result, test)
# [1] TRUE