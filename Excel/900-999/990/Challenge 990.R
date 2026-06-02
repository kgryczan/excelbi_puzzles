library(tidyverse)
library(readxl)
path <- "900-999/990/990 Final String After Edits.xlsx"
input <- read_excel(path, range = "A2:B32")
test <- read_excel(path, range = "D2:E7")

commands <- list(
  APPEND = \(stack, arg) c(stack, arg),
  DUP = \(stack, arg) c(stack, stack),
  REVERSE = \(stack, arg) rev(stack),
  DROP = \(stack, arg) head(stack, -1)
)
run_command <- function(stack, command) {
  parts <- str_split(command, ":", n = 2)[[1]]
  cmd <- parts[1]
  arg <- parts[2] %||% NA_character_
  commands[[cmd]](stack, arg)
}
run_commands <- function(command) {
  reduce(command, run_command, .init = character())
}
result = input %>%
  summarise(
    FinalText = list(run_commands(Command)) %>%
      unlist() %>%
      paste(collapse = ""),
    .by = Session
  )

all.equal(result, test)
#> [1] TRUE
