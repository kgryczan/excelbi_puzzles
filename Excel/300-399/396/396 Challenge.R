library(tidyverse)
library(readxl)

input = read_excel("Excel/396 Count Inversions.xlsx", range = "A1:A10")
test  = read_excel("Excel/396 Count Inversions.xlsx", range = "B1:B10")

check_inversions = function(x) {
  x = as.character(x)
  inversions = 0
  
  for (i in 1:(nchar(x) - 1)) {
    for (j in (i + 1):nchar(x)) {
      if (as.numeric(substr(x, i, i)) > as.numeric(substr(x, j, j))) {
        inversions = inversions + 1
      }
    }
  }
  return(inversions)
}

result = input %>%
  mutate(inversions = map_dbl(String, check_inversions))

identical(result$inversions, test$`Answer Expected`)
# [1] TRUE
