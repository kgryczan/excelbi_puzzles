library(tidyverse)
library(readxl)

path = "Excel/110 Scan.xlsx"
input = read_excel(path, range = "A2:G5", col_names = FALSE) %>% as.matrix()
test  = read_excel(path, range = "I2:O5", col_names = FALSE) %>% as.matrix()

output = matrix(NA, nrow = nrow(input), ncol = ncol(input))
for (i in 1:nrow(input)) {
  for (j in 1:ncol(input)) {
    output[i, j] = paste(input[i, 1:j], collapse = "")
  }
}

all.equal(output, test, check.attributes = FALSE)
#> [1] TRUE