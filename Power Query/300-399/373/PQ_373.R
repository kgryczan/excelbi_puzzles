library(dplyr)
library(readxl)
library(purrr)
library(stringr)

path <- "300-399/373/PQ_Challenge_373.xlsx"
input <- read_excel(path, range = "A1:D25")
test <- read_excel(path, range = "F1:J3")


process_user <- function(df) {
  stack <- character()
  walk2(df$Action, df$Value, \(a, v) {
    if (a == "Type") {
      stack <<- c(stack, v)
    }
    if (a == "Undo" && length(stack) > 0) stack <<- stack[-length(stack)]
  })
  tibble(
    FinalText = str_c(stack, collapse = ""),
    CharactersTyped = sum(df$Action == "Type"),
    UndoCount = sum(df$Action == "Undo"),
    FinalLength = length(stack)
  )
}

result <- input %>%
  arrange(Step) %>%
  group_by(User) %>%
  group_modify(~ process_user(.x)) %>%
  ungroup()

all.equal(result, test)
# CHaractersTyped column has different values that given.
