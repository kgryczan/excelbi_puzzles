library(tidyverse)
library(readxl)
library(data.table)

input = read_excel("Sumproduct Number.xlsx", range = "A1:A10")
test = read_excel("Sumproduct Number.xlsx", range = "B1:B3") 


is_sum_product_tv = function(number){
  digits = as.numeric(str_split(as.character(number), "")[[1]])
  
  sum = reduce(digits, `+`)
  product = reduce(digits, `*`)
  
  check = number %% sum == 0 & number %% product == 0
  return(check)
  
}
result_tv = input %>%
  mutate(my_answer = map_lgl(Number, is_sum_product_tv)) %>%
  filter(my_answer) %>%
  select(my_answer = Number)

identical(test$`Answer Expected`, result_tv$my_answer)
#[1] TRUE