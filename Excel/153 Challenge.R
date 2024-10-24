library(tidyverse)
library(readxl)

path = "Excel/153 Decimal to Binary.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10")

dec2bin = function(x) {
  if (x == 0) return(0)
  res = numeric(0)
  while (x > 0) {
    res = c(x %% 2, res)
    x = x %/% 2
  }
  return(paste(res, collapse = ""))
}

result = input %>%
  mutate(binary = map_chr(Number, dec2bin)) 
  
all.equal(result$binary, test$Binary, check.attributes = FALSE)
#> [1] TRUE