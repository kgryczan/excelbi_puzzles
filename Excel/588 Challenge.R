library(tidyverse)
library(readxl)

path = "Excel/588 Minimum Sum Pair.xlsx"
input = read_excel(path, range = "A1:D10")
test  = read_excel(path, range = "F1:F5") %>% select(1) %>% pull() 

process_column = function(column) {
  grid = combn(column, 2) %>% t() %>% data.frame() %>% mutate(sum = X1 + X2) %>% arrange(sum) %>% head(1)
  paste0(grid$X1, ", ", grid$X2)
}

result = map(input, process_column) %>% unlist()

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE