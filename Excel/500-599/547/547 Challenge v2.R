library(tidyverse)
library(readxl)

path = "Excel/547 Sum and Diff both Triangular Numbers.xlsx"
test  = read_excel(path, range = "A1:A21")

generate_triangular_numbers <- function(n) {
  triangulars <- numeric(n)
  for (i in 1:n) {
    triangulars[i] <- i * (i + 1) / 2 
  }
  return(triangulars)
}

is_triangular_number <- function(n) {
  return((sqrt(8 * n + 1) - 1) %% 2 == 0)
}

tr = generate_triangular_numbers(2000)


tr_pairs = expand.grid(tr, tr) %>%
  as_tibble() %>%
  filter(Var1 != Var2,
         Var1 < Var2,
         is_triangular_number(Var1 + Var2),
         is_triangular_number(abs(Var1 - Var2))) %>%
  arrange(Var1, Var2) %>%
  head(20) %>%
  unite("result", c(Var1, Var2), sep = ", ", remove = T)

identical(test$`Answer Expected`, tr_pairs$result)
#> [1] TRUE