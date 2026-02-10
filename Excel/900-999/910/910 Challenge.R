library(tidyverse)
library(readxl)

path <- "Excel/900-999/910/910 Increasing Numbers.xlsx"
input <- read_excel(path, range = "A1:A11")
test <- read_excel(path, range = "B1:B11")

split_inc <- function(s) {
  n <- nchar(s)
  if (n == 0) {
    character()
  }
  pos <- 1
  prev <- substr(s, pos, pos)
  out <- prev
  pos <- pos + 1
  while (pos <= n) {
    found <- FALSE
    for (len in 1:(n - pos + 1)) {
      cand <- substr(s, pos, pos + len - 1)
      if (as.integer(cand) > as.integer(prev)) {
        out <- c(out, cand)
        prev <- cand
        pos <- pos + len
        found <- TRUE
        break
      }
    }
    if (!found) break
  }
  paste(out, collapse = ", ")
}

result = input %>%
  mutate(`Answer Expected` = map_chr(`Digit Strings (Input)`, split_inc))

all.equal(result$`Answer Expected`, test$`Answer Expected`)
# > TRUE
