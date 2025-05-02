library(tidyverse)
library(readxl)

path = "Excel/014 Square Diagnonal Sum.xlsx"
input = read_excel(path, range = "A2:D5", col_names = FALSE) %>% as.matrix()
test = 27

result = sum(diag(input[, ncol(input):1])) - sum(diag(input))

print(result == test)
# [1] TRUE