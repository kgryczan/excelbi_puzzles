library(tidyverse)
library(readxl)
library(matrixStats)

path = "Excel/704 WhereMaxBlock.xlsx"
input = read_excel(path, range = "A3:J16", col_names = FALSE) %>% as.matrix()
test = read_excel(path, range = "L2:L3") %>% pull()

nr = nrow(input)
nc = ncol(input)

submatrices = expand.grid(
  i = 1:(nr - 1),
  j = 1:(nc - 1),
  k = 2:nr,
  l = 2:nc
) %>%
  filter(k > i, l > j) %>%
  pmap(function(i, j, k, l) input[i:k, j:l])


submatrices_df = tibble(
  sum = map_dbl(submatrices, ~ sum(.x, na.rm = TRUE)),
  dims = map_chr(submatrices, ~ paste(dim(.x), collapse = " x ")),
  start_cell = map_chr(
    submatrices,
    ~ paste(which(input == .x[1], arr.ind = TRUE)[1, ], collapse = " x ")
  )
) %>%
  slice_max(order_by = sum, n = 1)

result = glue::glue(
  "({submatrices_df$dims}), {submatrices_df$sum}, [{submatrices_df$start_cell}]"
)
