library(tidyverse)
library(readxl)

path <- "300-399/319/319 Powerful Numbers.xlsx"
input <- read_excel(path, range = "A1:A10")
test  <- read_excel(path, range = "B1:B6")

is_powerful <- function(n) {
  if (n == 1) return(TRUE)
  d <- 2L
  while (d * d <= n) {
    if (n %% d == 0) {
      exp <- 0L
      while (n %% d == 0) { exp <- exp + 1L; n <- n %/% d }
      if (exp < 2L) return(FALSE)
    }
    d <- d + 1L
  }
  n == 1L  # no prime factor left means all were squared
}

result <- input |>
  filter(map_lgl(Numbers, is_powerful)) |>
  select(`Answer Expected` = Numbers)

all.equal(result, test)
# [1] TRUE
