library(tidyverse)
library(readxl)

path = "Excel/574 Sort Numbers in Odd Positions Only.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10")

process_numbers = function(number) {
  number = strsplit(as.character(number), "")[[1]]
  odd = seq(1, length(number), by = 2)
  number[odd] = sort(as.numeric(number[odd]))
  paste(number, collapse = "")
}

result = input %>%
  mutate(`Answer Expected` = map_chr(Numbers, process_numbers))

all.equal(result$`Answer Expected`, test$`Answer Expected`)
#> [1] TRUE