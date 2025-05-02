library(tidyverse)
library(readxl)

path = "Excel/201 Next Number Distinct Digit.xlsx"
input = read_excel(path, range = "A1:A8")
test  = read_excel(path, range = "B1:B8")

find_next_number = function(start_number) {
  x = as.character(start_number)
 
  while(TRUE) {
    x = as.character(as.numeric(x) + 1)
    if(nchar(x) == length(unique(strsplit(x, "")[[1]]))) {
      return(as.numeric(x))
      break
    }
  }
}

result = input %>%
  mutate(`Expected Answer` = map_dbl(Number, find_next_number))

all.equal(result$`Expected Answer`, test$`Expected Answer`)
#> [1] TRUE