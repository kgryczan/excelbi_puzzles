library(tidyverse)
library(readxl)
library(janitor)

path = "Excel/523 Alphabets Staircase.xlsx"
given_number = read_excel(path, range = "B2", col_names = FALSE) %>% pull
test = read_excel(path, skip = 3, col_names = FALSE)

M = matrix(nrow = given_number, ncol = given_number * 2 + 1)

for (i in 1:given_number) {
  start_col <- 2 * (i - 1) + 1
  M[i, seq(start_col, start_col + 2)] = LETTERS[i]
}
M = as_tibble(M) %>% remove_empty(c("rows", "cols"))
colnames(M) = colnames(test)

identical(M, test)
#> [1] TRUE