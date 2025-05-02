library(tidyverse)
library(readxl)

path = "Excel/143 Harshad Number.xlsx"
input = read_excel(path, range = "A1:A9")
test  = read_excel(path, range = "B1:B5")

harshad = function(n) {
  n %% sum(as.numeric(strsplit(as.character(n), "")[[1]])) == 0
}

result = input %>%
  mutate(is_harshad = map_lgl(Number, harshad)) %>%
  filter(is_harshad) 

all.equal(result$Number, test$`Answer Expected`)
#> [1] TRUE          