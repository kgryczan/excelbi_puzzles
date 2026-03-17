library(tidyverse)
library(readxl)

path <- "300-399/316/316 Even Fibonacci Numbers.xlsx"
test <- read_excel(path, range = "A1:A21")

fib_even <- function(n) {
  result <- numeric(n)
  a <- 0
  b <- 1
  count <- 0
  while (count < n) {
    if (a %% 2 == 0) {
      count <- count + 1
      result[count] <- a
    }
    temp <- a + b
    a <- b
    b <- temp
  }
  result
}

result <- tibble(`First 20 Even Fibonnaci Numbers` = fib_even(20))

all.equal(result, test)
# [1] TRUE
