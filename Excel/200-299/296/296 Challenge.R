library(tidyverse)
library(stringi)
library(readxl)

input = read_excel("196-Algorithm.xlsx")

compute_196_palindrome = function(number) {
  original_number = number
  while (TRUE) {
    number = number + as.numeric(stri_reverse(as.character(number))) 
    
    if (as.character(number) == stri_reverse(as.character(number)) & number != original_number) {
      break
    }
  }
  return(number)
}

result = input %>%
  mutate(my_answer = map_dbl(Number, compute_196_palindrome), 
         check = `Expected Answer`== my_answer) 

print(result)