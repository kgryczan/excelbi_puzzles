library(tidyverse)
library(readxl)

path <- "Excel/800-899/891/891 Sum of Two Perfect Squares.xlsx"
input <- read_excel(path, range = "A1:A15")
test <- read_excel(path, range = "B1:B15")

find_square_pairs <- function(n) {
  limit <- floor(sqrt(n))
  pairs <- expand.grid(i = 0:limit, j = 0:limit) %>%
    filter(i <= j, i^2 + j^2 == n) %>%
    arrange(i, j) %>%
    mutate(pair = paste(i, j, sep = "-")) %>%
    pull(pair)
  if (length(pairs) == 0) {
    return("")
  }
  paste(pairs, collapse = ", ")
}

results <- input %>%
  mutate(
    Pairs = map_chr(Number, find_square_pairs),
    Pairs = ifelse(Pairs == '', "No", Pairs)
  )

all.equal(results$Pairs, test$`Answer Expected`, check.attributes = FALSE)
# 3rd solution is not correct
