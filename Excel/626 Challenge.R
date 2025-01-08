library(tidyverse)
library(readxl)

path = "Excel/626 List Unique Across Columns.xlsx"
input = read_excel(path, range = "A2:I20", col_names = FALSE)
test  = read_excel(path, range = "K2:S20", col_names = FALSE)


input <- input %>%
  map_df(~ .x %>%
           rev() %>%
           unique() %>%
           rev() %>%
           c(., rep(NA, nrow(input) - length(.))))

all.equal(input, test)
#> [1] TRUE