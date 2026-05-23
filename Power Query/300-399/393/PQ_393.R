library(tidyverse)
library(readxl)

path <- "300-399/393/PQ_Challenge_393.xlsx"
input <- read_excel(path, range = "A1:D21")
test <- read_excel(path, range = "F1:H11")

FIFO <- R6Class(
  "FIFO",
  public = list(
    stock = tibble(received = numeric(), qty = numeric(), expires = numeric()),
    clean = function(day) {
      self$stock <- self$stock |>
        filter(expires >= day, qty > 0) |>
        arrange(received)
    },
    receive = function(day, qty, shelf_life) {
      self$clean(day)
      self$stock <- bind_rows(
        self$stock,
        tibble(received = day, qty = qty, expires = day + shelf_life)
      )
    },
    issue = function(day, requested) {
      self$clean(day)
      fulfilled <- min(requested, sum(self$stock$qty))
      before <- lag(cumsum(self$stock$qty), default = 0)
      self$stock <- self$stock |>
        mutate(qty = qty - pmin(qty, pmax(fulfilled - before, 0))) |>
        filter(qty > 0)
      fulfilled
    },
    run = function(data) {
      data |>
        arrange(Day) |>
        mutate(
          FulfilledQty = pmap_dbl(
            list(Day, Type, Qty, ShelfLife),
            \(d, t, q, s) {
              if (t == "R") {
                self$receive(d, q, s)
                NA_real_
              } else {
                self$issue(d, q)
              }
            }
          )
        ) |>
        filter(Type == "I") |>
        transmute(Day, RequestedQty = Qty, FulfilledQty)
    }
  )
)

inv <- FIFO$new()
result <- inv$run(input)

all.equal(result, test)
# [1] TRUE
