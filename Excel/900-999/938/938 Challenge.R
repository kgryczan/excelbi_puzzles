library(tidyverse)
library(readxl)

path <- "900-999/938/938 Extract As Per Depth.xlsx"
input <- read_excel(path, range = "A1:B23")
test <- read_excel(path, range = "C1:C23")

extract_at_depth <- function(signal, target) {
  chars <- strsplit(signal, "")[[1]]
  depth <- 0
  result <- character(0)
  for (ch in chars) {
    if (ch == "(") {
      depth <- depth + 1
    } else if (ch == ")") {
      depth <- depth - 1
    } else if (depth == target) {
      result <- c(result, ch)
    }
  }
  if (length(result) == 0) NA_character_ else paste(result, collapse = "")
}

result <- input |>
  mutate(
    `Answer Expected` = map2_chr(Signal, `Target Depth`, extract_at_depth)
  ) |>
  select(`Answer Expected`)

all.equal(result, test)
# [1] TRUE
