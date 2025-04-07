library(tidyverse)
library(readxl)

path = "Excel/206 Square Root Contains the Number Itself.xlsx"
input = read_excel(path, range = "A1:A9")
test  = read_excel(path, range = "B1:B9")

check = function(x) {
  sqr = sqrt(x)
  xch = as.character(x)
  grepl(xch, formatC(sqr, digits = 15, format = "f"))
}

find_first_valid = function(start, predicate) {
  current <- start
  
  while (TRUE) {
    if (predicate(current)) {
      return(current)
    }
    current <- current + 1
  }
}

result = input %>%
  head(6) %>% # make 6 because of slow code
  rowwise() %>%
  mutate(res = find_first_valid(Numbers, check)) 

