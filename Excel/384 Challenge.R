library(tidyverse)
library(readxl)

input = read_excel("Excel/384 Extract Increasing Numbers.xlsx", range = "A1:A12")
test  = read_excel("Excel/384 Extract Increasing Numbers.xlsx", range = "B1:B12")

recursive_append <- function(n, p = 0, c = 1, a = 0) {
  if (p + c > nchar(n)) {
    return("")
  } else {
    v <- as.numeric(substr(n, p + 1, p + c))
    if (!is.na(v) && v > a) {
      b <- paste(", ", v, recursive_append(n, p + c, 1, v), sep = "")
    } else {
      b <- recursive_append(n, p, c + 1, a)
    }
    return(b)
  }
}

result = input %>%
  rowwise() %>%
  mutate(R = substring(recursive_append(as.character(Numbers)), 1)) %>%
  mutate(R = str_sub(R, 3, -1))

identical(result$R, test$`Answer Expected`)
# [1] TRUE





