library(tidyverse)
library(readxl)

path <- "900-999/967/967 Sum with Limits.xlsx"
input <- read_excel(path, range = "A1:C21")
test <- read_excel(path, range = "D1:D21")

sum_with_limits <- function(sequence, mode, limit) {
  nums <- str_split(sequence, ",\\s*")[[1]] |> as.integer()
  if (mode == "R") {
    nums <- rev(nums)
  }
  included <- c()
  breaks_used <- 0L
  for (num in nums) {
    if (length(included) == 0 || num > tail(included, 1)) {
      included <- c(included, num)
    } else if (breaks_used < limit) {
      included <- c(included, num)
      breaks_used <- breaks_used + 1L
    } else {
      break
    }
  }
  sum(included)
}
results <- input |>
  rowwise() |>
  mutate(Answer = sum_with_limits(Sequence, Mode, Limit)) |>
  ungroup()

all.equal(results$Answer, test$`Answer Expected`)
# [1] TRUE
