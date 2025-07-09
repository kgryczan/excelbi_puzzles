library(tidyverse)
library(readxl)

path = "Excel/200-299/255/255 Happy Numbers.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B6")

is_happy <- function(n) {
  map_lgl(n, ~ any(accumulate(1:20, ~ sum(as.integer(unlist(str_split(as.character(.x), "")))^2), .init = .x) == 1))
}

result = input %>%
  filter(is_happy(Numbers))

all.equal(result$Numbers, test$`Answer Expected`, check.attributes = FALSE) 
# > [1] TRUE