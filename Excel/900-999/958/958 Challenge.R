library(tidyverse)
library(readxl)

path <- "900-999/958/958 Wordle.xlsx"
input <- read_excel(path, range = "A1:B11")
test <- read_excel(path, range = "C1:C11")

score_word <- function(secret, guess) {
  s <- strsplit(secret, "")[[1]]
  g <- strsplit(guess, "")[[1]]
  result <- ifelse(s == g, "G", "B")
  used <- s == g
  for (i in seq_along(g)) {
    if (result[i] == "B") {
      idx <- which(!used & s == g[i])[1]

      if (!is.na(idx)) {
        result[i] <- "Y"
        used[idx] <- TRUE
      }
    }
  }
  paste(result, collapse = "")
}

result = input %>%
  mutate(`Answer Expected` = map2_chr(`Target Word`, `Guess Word`, score_word))
all.equal(result$`Answer Expected`, test$`Answer Expected`)
# [1] TRUE
