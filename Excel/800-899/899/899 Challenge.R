library(tidyverse)
library(readxl)

path <- "Excel/800-899/899/899 Sorting Sentences by Number.xlsx"
input <- read_excel(path, range = "A1:A11")
test <- read_excel(path, range = "B1:B11")

reorder_by_digits <- function(text) {
  str_split(text, " ")[[1]] |>
    (\(x) x[order(as.integer(str_extract(x, "\\d+")))])() |>
    str_remove_all("\\d+") |>
    str_c(collapse = " ")
}

result = input %>%
  mutate(reordered = map_chr(`Input Sentence`, reorder_by_digits))

all.equal(result$reordered, test$`Answer Expected`, check.attributes = FALSE)
# [1] TRUE
