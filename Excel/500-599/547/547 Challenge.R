library(tidyverse)
library(readxl)

path = "Excel/547 Sum and Diff both Triangular Numbers.xlsx"
test  = read_excel(path, range = "A1:A21")

generate_triangular_numbers <- function(limit) {
  n <- 1
  triangulars <- c()
  
  while (TRUE) {
    t_n <- n * (n + 1) / 2
    if (t_n > limit) break
    triangulars <- c(triangulars, t_n)
    n <- n + 1
  }
  return(triangulars)
}

is_triangular_number <- function(n) {
  return((sqrt(8 * n + 1) - 1) %% 2 == 0)
}


tr = generate_triangular_numbers(1000000)

tr_pairs = expand.grid(tr, tr) %>%
  as_tibble() %>%
  filter(Var1 != Var2,
         Var1 < Var2,
         is_triangular_number(Var1 + Var2),
         is_triangular_number(abs(Var1 - Var2))) %>%
  arrange(Var1, Var2) %>%
  head(20) %>%
  unite("result", c(Var1, Var2), sep = ", ", remove = T)

print(tr_pairs)
