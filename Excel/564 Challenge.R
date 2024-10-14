library(tidyverse)
library(readxl)

path = "Excel/564 Sort Numbers only.xlsx"
input = read_excel(path, range = "A2:D11") 
test  = read_excel(path, range = "F2:I11")

process_column = function(col) {
  letters = grep("[A-Za-z]", col)
  num_positions = grep("[0-9]", col)
  numbers = as.numeric(col[num_positions])
  numbers = sort(numbers)
  col[num_positions] = numbers
  return(col)
}

input = input %>% map_df(process_column)

all.equal(input, test)
#> [1] TRUE