library(tidyverse)
library(readxl)

path = "Excel/104 Fibonacci Strings.xlsx"
input = read_excel(path, range = "A1:C6")
test  = read_excel(path, range = "D1:D6")

fibonacci_string = function(first, second, n) {
  if (n == 1) return(first)
  if (n == 2) return(second)
  
  fib_strings <- character(n)
  fib_strings[1] <- first
  fib_strings[2] <- second
  
  for (i in 3:n) {
    fib_strings[i] <- paste0(fib_strings[i - 2], fib_strings[i - 1])
  }
  return(fib_strings)
}

result = input %>%
  mutate(Answer = pmap(list(First, Second, n), fibonacci_string)) %>%
  unnest(Answer) %>%
  summarise(Answer = str_c(Answer, collapse = ", "), .by = c(First, Second, n))

all.equal(result$Answer, test$Answer, check.attributes = FALSE)
# FAlSe