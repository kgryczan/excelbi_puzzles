library(tidyverse)
library(readxl)

path = "Excel/120 Scan2.xlsx"
input = read_excel(path, range = "A2:D4", col_names = FALSE) %>% as.matrix()
test  = read_excel(path, range = "F2:I4", col_names = FALSE) %>% as.matrix()

output = matrix(NA_character_, nrow = nrow(input), ncol = ncol(input))

for (i in 1:nrow(input)) {
  for (j in 1:ncol(input)) {
    output[i, j] = paste(input[i, j:ncol(input)], collapse = "")
  }
}

all.equal(output, test, check.attributes = FALSE)
#> [1] TRUE