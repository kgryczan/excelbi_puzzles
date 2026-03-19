library(tidyverse)
library(readxl)

path <- "900-999/937/937 Number Equal to Sum of Digits.xlsx"
df <- read_excel(path, range = "A1:B13")
colnames(df) <- c("Number", "Expected")

smallest_digit_sum <- function(N) {
  d <- max(2, ceiling(N / 9))
  first <- N - 9 * (d - 1)
  if (first <= 0) {
    as.numeric(paste0("1", N - 1))
  } else {
    as.numeric(paste0(first, paste(rep("9", d - 1), collapse = "")))
  }
}

result <- df |>
  mutate(Result = map_dbl(Number, smallest_digit_sum))

all.equal(result$Result, result$Expected)
# [1] TRUE
