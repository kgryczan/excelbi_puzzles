library(tidyverse)
library(readxl)

path <- "900-999/952/952 Minimum Button Presses.xlsx"
input <- read_excel(path, range = "A1:B9")
test <- read_excel(path, range = "C1:C9")

min_presses <- function(start, target) {
  steps <- 0L
  while (target > start) {
    if (target %% 2L == 0L) {
      target <- target %/% 2L
    } else {
      target <- target + 1L
    }
    steps <- steps + 1L
  }
  steps + (start - target)
}

result = input %>%
  mutate(presses = map2_int(Start, Target, min_presses))

all.equal(result$presses, test$`Answer Expected`)
