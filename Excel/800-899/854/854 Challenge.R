library(tidyverse)
library(readxl)

path <- "Excel/800-899/854/854 Sum of Digits Min and Max.xlsx"
input <- read_excel(path, range = "A2:B10")
test <- read_excel(path, range = "C2:D10")

max = function(n, s) {
  if (s < 9) {
    m = paste0(s, paste0(rep(0, n - 1), collapse = ""))
  } else {
    digits = c()
    while (s > 9) {
      digits = c(digits, 9)
      s = s - 9
      n = n - 1
    }
    m = paste0(
      paste0(digits, collapse = ""),
      s,
      paste0(rep(0, n - 1), collapse = "")
    )
  }
  return(m)
}

min = function(n, s) {
  if (s < 9) {
    m = paste(1, paste0(rep(0, n - 2), collapse = ""), s - 1, sep = "")
  } else {
    digits = c()
    s = s - 1
    while (s > 9) {
      digits = c(digits, 9)
      s = s - 9
      n = n - 1
    }
    digits = c(digits, s)
    n = n - 1
    m = paste0(
      1,
      paste0(rep(0, n - 1), collapse = ""),
      paste0(rev(digits), collapse = "")
    )
  }
}

results <- input %>%
  mutate(
    `Min Number` = map2_chr(`Number of Digits`, `Sum of Digits`, min) %>%
      as.numeric(),
    `Max Number` = map2_chr(`Number of Digits`, `Sum of Digits`, max) %>%
      as.numeric()
  ) %>%
  select(`Min Number`, `Max Number`)

all.equal(results, test)
# one difference
