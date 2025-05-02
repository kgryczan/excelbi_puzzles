library(tidyverse)
library(readxl)

input = read_excel("Excel/429 Pythagorean Quadruples.xlsx", range = "A1:A10")
test  = read_excel("Excel/429 Pythagorean Quadruples.xlsx", range = "B1:B10")

find_quadr_solution = function(sides) {
  numbers = str_split(sides, ", ")[[1]] %>% 
    as.numeric() %>%
    na.omit()
  
  missing1 = sqrt(sum(numbers^2)) # if d side is missing
  
  pot_d = max(numbers)
  others = numbers[numbers != pot_d]
  missing2 = sqrt(pot_d^2 - sum(others^2)) # if a, b or c side is missing

  if (missing1 == floor(missing1)) {
    missing = missing1
  } else if (missing2 == floor(missing2)) {
    missing = missing2
  } else {
    missing = NA
  }

  return(missing)
}

result = input %>%
  mutate(r = map_dbl(Number, find_quadr_solution)) 

identical(result$r, test$`Answer Expected`)
# [1] TRUE
