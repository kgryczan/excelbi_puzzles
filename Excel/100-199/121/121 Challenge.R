library(tidyverse)
library(readxl)

path = "Excel/121 Digital Root.xlsx"
input = read_excel(path, range = "A1:A8")
test  = read_excel(path, range = "B1:B8")

digital_root = function(n) {
  while(n > 9) {
    n = sum(as.numeric(strsplit(as.character(n), "")[[1]]))
  }
  return(n)
}

result = input %>%
  mutate(Number = as.numeric(Number)) %>%
  mutate(Digital_Root = map_dbl(Number, digital_root))

result$Digital_Root == test$Answer
# [1]  TRUE  TRUE  TRUE  TRUE FALSE  TRUE  TRUE