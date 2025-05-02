library(tidyverse)
library(readxl)

path = "Excel/508 Number is Perfect Square and Sum of Squares of Digits is also a Perfect Square.xlsx"
test = read_excel(path, range = "A1:A501")

is_perfect_square <- function(n) {
  sqrt_n <- sqrt(n)
  sqrt_n == floor(sqrt_n)
}

result <- integer(0)
i <- 1


while (length(result) < 500) {
  if (nchar(as.character(test[i, 1])) > 1) {
    if (is_perfect_square(test[i, 1]) && is_perfect_square(sum(as.numeric(strsplit(as.character(test[i, 1]), "")[[1]])^2))) {
      result <- c(result, test[i, 1])
    }
  }
  i <- i + 1
}

result = data.frame(Result =  unlist(result))

identical(result$Result, test$`Answer Expected`)
# [1] TRUE
