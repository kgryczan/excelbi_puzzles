library(tidyverse)
library(readxl)
library(purrr)

path <- "900-999/943/943 Next 3 Distinct Digit Numbers.xlsx"
input <- read_excel(path, range = "A1:A10")
test <- read_excel(path, range = "B1:D10")

get_distinct_digits <- function(x) {
  x <- x + 1
  while (
    length(unique(str_split(x, "")[[1]])) != length(str_split(x, "")[[1]])
  ) {
    x <- x + 1
  }
  x
}

next3 <- function(n) {
  accumulate(1:3, ~ get_distinct_digits(.x), .init = n)[-1]
}

result = input %>%
  mutate(next3 = map(Numbers, next3)) %>%
  unnest_wider(next3, names_sep = "_")

all.equal(result$next3_1, test$`Answer Expected`) # TRUE
all.equal(result$next3_2, test$...2) # TRUE
all.equal(result$next3_3, test$...3) # TRUE
