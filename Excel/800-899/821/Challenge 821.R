library(tidyverse)
library(readxl)

path = "Excel/800-899/821/821 Pascal Triangle Variation.xlsx"
input = read_excel(path, range = "B2:B10", col_names = FALSE) %>% pull(1)
test  = read_excel(path, range = "E2:U10", col_names = FALSE) %>% as.matrix()

generate_custom_pascal <- function(signs) {
  n <- length(signs) 
  triangle <- matrix(NA, n, 2 * n - 1)
  triangle[1, n] <- 1

  for (i in 2:n) {
    for (j in (n - (i - 1)):(n + (i - 1))) {
      left <- ifelse(j - 1 < 1, 0, triangle[i - 1, j - 1])
      right <- ifelse(j + 1 > (2 * n - 1), 0, triangle[i - 1, j + 1])
      if (is.na(left) & is.na(right)) {
        triangle[i, j] <- NA
      } else {
        left <- ifelse(is.na(left), 0, left)
        right <- ifelse(is.na(right), 0, right)
        if (signs[i] == "+") {
          triangle[i, j] <- left + right
        } else if (signs[i] == "*") {
          left <- ifelse(left == 0, 1, left)
          right <- ifelse(right == 0, 1, right)
          triangle[i, j] <- left * right
        }
      }
    }
  } 

  triangle
}

result <- generate_custom_pascal(input)

all(result == test, na.rm = TRUE)
# [1] TRUE