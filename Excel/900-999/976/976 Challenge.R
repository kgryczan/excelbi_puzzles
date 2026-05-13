library(tidyverse)
library(readxl)

path <- "900-999/976/976 LIFO Stack.xlsx"
input <- read_excel(path, range = "A1:B26")
test <- read_excel(path, range = "C1:C26") |> na.omit() |> pull()

commands <- tolower(trimws(as.character(input[[1]])))
values <- suppressWarnings(as.numeric(input[[2]]))
state <- list(
  stack = numeric(0),
  max_stack = numeric(0),
  max_outputs = numeric(0)
)
state <- reduce2(
  commands,
  values,
  function(acc, cmd, v) {
    if (cmd == "push" && !is.na(v)) {
      new_max <- if (length(acc$max_stack) == 0) {
        v
      } else {
        max(v, tail(acc$max_stack, 1))
      }
      acc$stack <- c(acc$stack, v)
      acc$max_stack <- c(acc$max_stack, new_max)
    } else if (cmd == "pop" && length(acc$stack) > 0) {
      acc$stack <- head(acc$stack, -1)
      acc$max_stack <- head(acc$max_stack, -1)
    } else if (cmd == "max") {
      acc$max_outputs <- c(
        acc$max_outputs,
        if (length(acc$max_stack) > 0) tail(acc$max_stack, 1) else NA_real_
      )
    }
    acc
  },
  .init = state
)

all.equal(state$max_outputs, test)
## [1] TRUE
