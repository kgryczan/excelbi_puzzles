library(tidyverse)
library(readxl)

path <- "900-999/968/968 Triangle Patterns.xlsx"
input1 <- read_excel(path, range = "A2:A2", col_names = FALSE) %>%
  pull() %>%
  str_split(",") %>%
  unlist() %>%
  as.integer()
input2 <- read_excel(path, range = "A6:A6", col_names = FALSE) %>%
  pull() %>%
  str_split(",") %>%
  unlist() %>%
  as.integer()
input3 <- read_excel(path, range = "A9:A9", col_names = FALSE) %>%
  pull() %>%
  str_split(",") %>%
  unlist() %>%
  as.integer()
test1 <- read_excel(path, range = "B2:R4", col_names = FALSE) %>% as.matrix()
test2 <- read_excel(path, range = "B6:L7", col_names = FALSE) %>% as.matrix()
test3 <- read_excel(path, range = "B9:V14", col_names = FALSE) %>% as.matrix()

build_pattern_matrix <- function(amplitude, waves, symbol = "X") {
  wave <- rep(c(amplitude:1, 2:amplitude), waves)
  pattern <- wave[c(TRUE, diff(wave) != 0)]
  M <- matrix(NA_character_, nrow = amplitude, ncol = length(pattern))
  for (i in seq_along(pattern)) {
    M[pattern[i], i] <- symbol
  }
  M
}

M1 <- build_pattern_matrix(input1[1], input1[2])
M2 <- build_pattern_matrix(input2[1], input2[2])
M3 <- build_pattern_matrix(input3[1], input3[2])

compare_with_na <- function(a, b) {
  a <- unname(a)
  b <- unname(b)
  identical(is.na(a), is.na(b)) &&
    identical(unname(a[!is.na(a)]), unname(b[!is.na(b)]))
}

compare_with_na(M1, test1)
compare_with_na(M2, test2)
compare_with_na(M3, test3)
