library(tidyverse)
library(readxl)

path <- "300-399/396/PQ_Challenge_396.xlsx"
input <- read_excel(path, range = "A1:B32")
test <- read_excel(path, range = "E1:F4")

tokens <- purrr::reduce(
  input$Token,
  .init = character(),
  .f = ~ if (length(.x) > 0 && dplyr::last(.x) == .y) {
    head(.x, -1)
  } else {
    c(.x, .y)
  }
)

result = input %>%
  filter(Token %in% tokens)

all.equal(result, test)
# [1] TRUE
