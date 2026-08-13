library(tidyverse)
library(readxl)

path <- "1000-1099/1042/1042 Stack Processing.xlsx"
input <- read_excel(path, range = "A1:B15")
test <- read_excel(path, range = "C1:C15")

collapse <- function(x, m) {
  Reduce(
    \(s, v) {
      s <- c(s, v)
      while (length(s) > 1 && s[length(s) - 1] %% m == s[length(s)] %% m) {
        s <- c(head(s, -2), sum(tail(s, 2)))
      }
      s
    },
    x,
    init = numeric()
  )
}

result <- input %>%
  transmute(
    `Answer Expected` = map2_chr(
      Tokens,
      Modulus,
      \(x, m) {
        str_split_1(x, " ") %>%
          as.numeric() %>%
          collapse(m) %>%
          str_c(collapse = " ")
      }
    )
  )

all.equal(result, test)
# True
