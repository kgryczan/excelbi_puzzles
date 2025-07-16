library(tidyverse)
library(readxl)

get_digits <- function(n) {
  as.numeric(str_split(as.character(n), "")[[1]])
}

diff_adjacent <- function(digits) {
  map2_dbl(digits[-length(digits)], # list of digits except last element
           digits[-1], # list of digits except first element 
           # that gives us two lists shifted by one position
           ~abs(.x - .y))
}

reduce_number <- function(n) {
  digits <- get_digits(n)
  
  if(length(digits) == 1) {
    return(digits)
  }
  
  new_digits <- diff_adjacent(digits)
  
  new_num <- as.numeric(paste0(new_digits, collapse = ''))
  
  reduce_number(new_num) # recursion
}

input = read_excel("Reduce Number to a Single Digit.xlsx")


result = input %>%
  mutate(my_answer = map_int(Number, reduce_number),
         test = Answer == my_answer) 