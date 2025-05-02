library(tidyverse)
library(readxl)

path = "Excel/687 Fill Grid with Max Right and Down.xlsx"
input = read_excel(path, range = "A2:J11", col_names = FALSE) %>% as.matrix()
test  = read_excel(path, range = "A14:J23", col_names = FALSE) %>% as.matrix()

fill_empty = function(matrix, row, col){
  max = max(c(matrix[row, col:ncol(matrix) ], matrix[row:nrow(matrix), col]), na.rm = TRUE)
  return(max)
}
empty_cells = which(is.na(input), arr.ind = TRUE)
test_values = test[empty_cells]

filled_values = as.data.frame(empty_cells) %>%
  mutate(value = map2_dbl(row, col, ~ fill_empty(input, .x, .y))) %>%
  select(value)

all.equal(filled_values$value, test_values)
# [1] TRUE