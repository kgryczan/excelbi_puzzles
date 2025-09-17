library(tidyverse)
library(readxl)

path = "Excel/300-399/302/302 Vigenere Cipher Grid.xlsx"
test  = read_excel(path, range = "B2:AA28") %>% as.matrix()

result = matrix(NA, nrow = 26, ncol = 26)
for (i in 0:25) {
  for (j in 0:25) {
    result[i + 1, j + 1] = LETTERS[(i + j) %% 26 + 1]
  }
}

all.equal(test, result, check.attributes = FALSE)
#> TRUE