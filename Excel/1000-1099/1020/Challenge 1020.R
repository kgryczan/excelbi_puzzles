library(tidyverse)
library(readxl)

path <- "1000-1099/1020/1020 Running Total with Condition.xlsx"
input <- read_excel(path, range = "A1:A21")
test <- read_excel(path, range = "B1:B21")

running_total <- function(s) {
  accumulate(
    s,
    .init = list(total = 0, flip = FALSE),
    \(state, x) {
      case_when(
        x == "FLIP" ~ list(list(total = state$total, flip = !state$flip)),
        x == "RESET" ~ list(list(total = 0, flip = FALSE)),
        state$flip ~ list(list(
          total = max(0, state$total - as.numeric(x)),
          flip = TRUE
        )),
        TRUE ~ list(list(
          total = state$total + as.numeric(x),
          flip = FALSE
        ))
      )[[1]]
    }
  ) %>%
    tail(-1) %>%
    map_dbl("total")
}

result <- running_total(input$Signal)
all.equal(result, test$`Answer Expected`)
# True
