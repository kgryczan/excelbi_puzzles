library(dplyr)
library(readxl)
library(purrr)

path <- "300-399/375/PQ_Challenge_375.xlsx"
input <- read_excel(path, range = "A1:D43")
test <- read_excel(path, range = "G1:H3") |>
  filter(!is.na(User))


simulate_typing <- function(df) {
  history <- list()
  current <- ""

  walk2(df$Action, df$Value, \(action, value) {
    if (action == "Type") {
      history[[length(history) + 1]] <<- current
      current <<- paste0(current, value)
    } else if (action == "Backspace") {
      n <- as.integer(value)
      history[[length(history) + 1]] <<- current
      current <<- substr(current, 1, nchar(current) - n)
    } else if (action == "Undo") {
      if (length(history) > 0) {
        current <<- history[[length(history)]]
        history[[length(history)]] <<- NULL
      }
    }
  })

  tibble(`Final Typed` = current)
}

result <- input |>
  arrange(Step) |>
  group_by(User) |>
  group_modify(~ simulate_typing(.x)) |>
  ungroup()

identical(result, test)
# TRUE
