library(tidyverse)
library(readxl)

path = "Excel/497 Sum for Increasing Range.xlsx"
input = read_excel(path, range = "A1:A100")
test  = read_excel(path, range = "C1:D15")

is_triangular = function(n) {
  n = 8 * n + 1
  return(floor(sqrt(n)) == sqrt(n))
}

result <- input %>%
  mutate(row = row_number(),
         triangular = is_triangular(row),
         cumsum = cumsum(triangular),
         Cells = ifelse(!triangular, cumsum + 1, cumsum)) %>%
  summarise(Sum = sum(Numbers), .by = Cells) %>%
  mutate(Cells = ifelse(Cells == max(Cells), "Remaining", Cells))

identical(result, test)
#> [1] TRUE
