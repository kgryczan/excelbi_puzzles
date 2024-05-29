library(tidyverse)
library(readxl)

test = read_excel("Excel/466 Bouncy Numbers.xlsx", range = "A1:A10001")

is_bouncy = function(n) {
  digits = str_split(as.character(n), "")[[1]] %>% as.integer()
  is_decreasing = all(digits == cummax(digits))
  is_increasing = all(digits == cummin(digits))
  return(!is_decreasing & !is_increasing)
}

find_bouncy_numbers = function(limit) {
  bouncy_numbers = integer(limit)
  count = 0
  num = 100
  
  while (count < limit) {
    if (is_bouncy(num)) {
      count = count + 1
      bouncy_numbers[count] = num
    }
    num = num + 1
  }
  bouncy_numbers
}

bouncy_numbers = find_bouncy_numbers(10000)

all.equal(as.numeric(test$`Answer Expected`), bouncy_numbers) 
# TRUE
