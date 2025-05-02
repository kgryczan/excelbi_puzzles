library(tidyverse)
library(readxl)

path = "Excel/666 Fill in Blanks.xlsx"
input = read_excel(path, range = "A2:D11")
test  = read_excel(path, range = "F2:I11")

fill_missing_values <- function(row) {
  na_index <- which(is.na(row[-1])) + 1
  if (length(na_index) > 0) {
    row[na_index] <- (row$Total - sum(row[-1], na.rm = TRUE)) / length(na_index)
  }
  return(row)
}

result = input
for (i in 1:nrow(input)) {
  result[i,] <- fill_missing_values(input[i,])
}

all.equal(result, test)
#> [1] TRUE