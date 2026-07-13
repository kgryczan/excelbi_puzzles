library(tidyverse)
library(readxl)

path <- "1000-1099/1019/1019 Painated Text.xlsx"
input <- read_excel(path, range = "A2:A24")
test <- read_excel(path, range = "C2:E13")

lines <- input %>%
  pull(Word) %>%
  reduce(
    \(out, word) {
      candidate <- if (length(out)) str_c(last(out), word, sep = " ") else word

      if (length(out) && str_length(candidate) <= 15) {
        c(head(out, -1), candidate)
      } else {
        c(out, word)
      }
    },
    .init = character()
  )

result <- tibble(
  PageNumber = (seq_along(lines) - 1) %/% 3 + 1,
  LineNumber = (seq_along(lines) - 1) %% 3 + 1,
  LineText = lines
)

all.equal(result, test)
# True
