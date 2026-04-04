library(tidyverse)
library(readxl)
library(R6)

path <- "300-399/379/PQ_Challenge_379.xlsx"
input <- read_excel(path, range = "A1:D21")
test <- read_excel(path, range = "F1:G11")

Deque <- R6Class(
  "Deque",
  public = list(
    q = list(),
    push_back = function(x) self$q <- c(self$q, list(x)),
    push_front = function(x) self$q <- c(list(x), self$q),
    pop_front = function() {
      x <- self$q[[1]]
      self$q <- self$q[-1]
      x
    },
    peek = function() self$q[[1]],
    empty = function() length(self$q) == 0
  )
)
fifo <- Deque$new()
res <- input %>%
  mutate(
    Profit = pmap_dbl(list(Type, Coins, Price), \(type, qty, price) {
      if (type == "BUY") {
        fifo$push_back(c(qty, price))
        return(NA_real_)
      }
      need <- qty
      cost <- 0
      while (need > 0) {
        lot <- fifo$pop_front()
        take <- min(lot[1], need)
        cost <- cost + take * lot[2]
        remaining <- lot[1] - take
        if (remaining > 0) {
          fifo$push_front(c(remaining, lot[2]))
        }
        need <- need - take
      }
      qty * price - cost
    })
  ) %>%
  filter(Type == "SELL") %>%
  select(TransactionID, Profit)

all.equal(res, test)
## [1] TRUE
