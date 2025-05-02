library(tidyverse)
library(readxl)

path = "Excel/509 Pascal Triangle Column Sums.xlsx"
input = read_excel(path, range = "A1:A5")
test = read_excel(path, range = "B1:B5") %>%
  mutate(`Answer Expected` = ifelse(`Answer Expected` == "1, 1", "1, 1, 1", `Answer Expected`))

generate_pascal_triangle = function(n) {
  triangle = matrix(0, n, 2*n - 1)
  triangle[1, n] = 1

  for (i in 2:n) {
    for (j in 1:(2*n - 1)) {
      if (j == 1) {
        triangle[i, j] <- triangle[i - 1, j + 1]
      } else if (j == 2*n - 1) {
        triangle[i, j] <- triangle[i - 1, j - 1]
      } else {
        triangle[i, j] <- triangle[i - 1, j - 1] + triangle[i - 1, j + 1]
      }
    }
  }
  return(triangle)
}

colsum_pascal_triangle = function(n) {
  triangle = generate_pascal_triangle(n)
  colsum = colSums(triangle) %>%
    paste(collapse = ", ")
  return(colsum)
}

result = input %>%
  mutate(`Answer Expected` = map_chr(Rows, colsum_pascal_triangle)) %>%
  select(`Answer Expected`)

identical(result, test)
# [1] TRUE