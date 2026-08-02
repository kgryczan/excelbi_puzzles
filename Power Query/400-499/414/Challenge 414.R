library(tidyverse)
library(readxl)

p <- "400-499/414/PQ_Challenge_414.xlsx"
tx <- read_excel(p, range = "A1:C25")
expected <- read_excel(p, range = "E1:J13") %>%
  mutate(across(
    c(`Purchase Date`, `Last Valid Renewal`, `Expiry Date`),
    as.Date
  ))

cycles <- function(d) {
  step <- function(state, row) {
    rows <- state$rows
    current <- state$current
    date <- as.Date(row$`Transaction Date`)
    if (row$Type == "Purchase") {
      return(list(
        rows = c(rows, compact(list(current))),
        current = list(
          Customer = row$Customer,
          Cycle = length(rows) + 1 + !is.null(current),
          `Purchase Date` = date,
          `Last Valid Renewal` = date,
          `Successful Renewals` = 0,
          `Expiry Date` = date + 90
        )
      ))
    }
    if (!is.null(current) && date == current$`Expiry Date`) {
      current$`Last Valid Renewal` <- date
      current$`Successful Renewals` <- current$`Successful Renewals` + 1
      current$`Expiry Date` <- date + 90
    } else if (!is.null(current) && date > current$`Expiry Date`) {
      return(list(rows = c(rows, list(current)), current = NULL))
    }
    list(rows = rows, current = current)
  }
  state <- d %>%
    arrange(`Transaction Date`) %>%
    split(seq_len(nrow(.))) %>%
    reduce(step, .init = list(rows = list(), current = NULL))
  bind_rows(compact(c(state$rows, list(state$current))))
}

result <- tx %>%
  group_split(Customer) %>%
  map_dfr(cycles) %>%
  select(names(expected))
print(all.equal(result, expected))
