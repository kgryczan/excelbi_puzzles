library(tidyverse)
library(readxl)
library(charcuterie)

path <- "Excel/800-899/858/858 Top 3 Digits in First 50 Fibonacci Numbers.xlsx"
test <- read_excel(path, range = "A2:B5")

result <- Reduce(
  function(a, ...) c(a, sum(tail(a, 2))),
  1:48,
  init = c(0, 1)
) |>
  as.character() |>
  paste0(collapse = "") |>
  chars() |>
  table() |>
  as.data.frame() |>
  rename(Digit = 1, Frequency = 2) |>
  mutate(Digit = as.character(Digit)) |>
  slice_max(Frequency, n = 3)

all.equal(test, result, check.attributes = FALSE)
