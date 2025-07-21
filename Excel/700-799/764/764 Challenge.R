library(tidyverse)
library(readxl)

path = "Excel/700-799/764/764 Reverse Polish Notation_2.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10")

eval_rpn = function(tokens) {
  stack = c()
  for (t in tokens) {
    if (t %in% c('+', '-', '*', '/')) {
      if (length(stack) > 2) {
        res = stack[1]
        for (n in stack[-1]) {
          res = eval(parse(text = paste0(res, t, n)))
        }
        stack = res
      } else {
        b = tail(stack, 1)
        a = tail(stack, 2)[1]
        stack = c(head(stack, -2), eval(parse(text = paste0(a, t, b))))
      }
    } else {
      stack = c(stack, as.numeric(t))
    }
  }
  stack[1]
}

result = input %>%
  mutate(Result = map_dbl(Text, ~eval_rpn(strsplit(.x, ", ")[[1]])))

all.equal(result$Result, test$`Expected Answer`) 
# [1] TRUE
