library(tidyverse)
library(readxl)

input = read_excel("Excel/412 Square Sum Iterate till a Single Digit .xlsx", range = "A2:A11")
test  = read_excel("Excel/412 Square Sum Iterate till a Single Digit .xlsx", range = "B2:C11")

sum_square <- function(x) {
  iter <- 0
  
  if (nchar(x) == 1) {
    y <- x^2
    iter <- iter + 1
  } else {
    y <- x
  }
  
  while (nchar(y) > 1) {
    digits <- as.numeric(strsplit(as.character(y), "")[[1]])
    y <- sum(digits^2)
    iter <- iter + 1
  }
  return(c(iter, y))
}

result = input %>%
  mutate( r = map(Number, sum_square), 
          FSD = map_dbl(r, 2),
          Iterations = map_dbl(r, 1)) %>%
  select(-c(r, Number)) 

all.equal(result, test, check.attributes = FALSE, ignore.names = TRUE)
# [1] TRUE

