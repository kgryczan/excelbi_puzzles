library(tidyverse)
library(readxl)

input = read_excel("Reverse Polish Notation.xlsx")


eval_srpn = function(string) {
  tokens = str_split(string, pattern = ", ")[[1]]
  operator = tail(tokens,1)
  numbers = head(tokens, -1) %>% map_dbl(~ as.numeric(.x))
  
  result = reduce(numbers, ~ {
    switch(
      operator,
      "+" = .x + .y,
      "-" = .x - .y,
      "*" = .x * .y,
      "/" = .x / .y)
  })
  return(result)
}

result = input %>%
  mutate(my_answer = map_dbl(Text, eval_srpn),
         check = my_answer == `Expected Answer`) 