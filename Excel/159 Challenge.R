library(tidyverse)
library(readxl)

path = "Excel/159 Reverse Columns.xlsx"
input = read_excel(path, range = "A1:E19")
test  = read_excel(path, range = "G2:K20")

reverse_column <- function(col) {
  non_na <- col[!is.na(col)]
  reversed <- rev(non_na)
  c(reversed, rep(NA, sum(is.na(col))))
}

result = input %>% map_df(reverse_column)

all.equal(result, test)
#> [1] TRUE