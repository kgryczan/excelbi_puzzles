library(tidyverse)
library(readxl)

path = "Excel/700-799/712/712 Rotate Quadrangle.xlsx"
input = read_excel(path, range = "A2:I10", col_names = FALSE) %>% as.matrix()
test = read_excel(path, range = "L2:T10", col_names = FALSE) %>% as.matrix()

coords = which(!is.na(input), arr.ind = TRUE) %>%
  as_tibble() %>%
  mutate(value = input[cbind(row, col)])

shift <- function(r, c) {
  case_when(
    r <= 5 & c <= 4 ~ c(r - 1, c + 1),
    r <= 4 & c >= 5 ~ c(r + 1, c + 1),
    r >= 5 & c >= 6 ~ c(r + 1, c - 1),
    r >= 6 & c <= 5 ~ c(r - 1, c - 1),
    TRUE ~ c(r, c)
  )
}

coords = coords %>%
  mutate(shifted = map2(row, col, ~ shift(.x, .y))) %>%
  mutate(new_row = map_dbl(shifted, 1), new_col = map_dbl(shifted, 2))

output = matrix(NA, nrow = 9, ncol = 9)
for (i in 1:nrow(coords)) {
  r = coords$new_row[i]
  c = coords$new_col[i]
  v = coords$value[i]
  output[r, c] = v
}

all.equal(output, test, check.attributes = FALSE)
# [1] TRUE
