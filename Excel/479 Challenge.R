library(tidyverse)
library(readxl)
library(tictoc)
library(memoise)

path = "Excel/479 Recaman Sequence.xlsx"
test = read_excel(path)

recaman_sequence <- function(n) {
  recaman <- integer(n)
  recaman[1] <- 0
  seen <- setNames(logical(n * 3), 0:(n * 3 - 1))
  seen[1] <- TRUE
  
  for (i in 2:n) {
    prev_value <- recaman[i - 1]
    next_value <- prev_value - (i - 1)
    
    if (next_value > 0 && !seen[next_value + 1]) {
      recaman[i] <- next_value
    } else {
      next_value <- prev_value + (i - 1)
      recaman[i] <- next_value
    }
    
    seen[recaman[i] + 1] <- TRUE
  }
  
  return(recaman)
}

tic()
recaman_sequence(10000)
toc()
#  0.05 sec elapsed

result = recaman_sequence(10000)
identical(result, test$`Answer Expected`)
# [1] TRUE