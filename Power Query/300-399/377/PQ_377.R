library(readxl)
library(dplyr)
library(tidyr)
library(R6)

input <- read_excel("300-399/377/PQ_Challenge_377.xlsx", range = "A1:D21")
test <- read_excel("300-399/377/PQ_Challenge_377.xlsx", range = "G1:I3")

Robot <- R6Class(
  "Robot",
  public = list(
    x = 0,
    y = 0,
    initialize = function(start) {
      coords <- strsplit(start, ",")[[1]] |> as.numeric()
      self$x <- coords[1]
      self$y <- coords[2]
    },
    move = function(action, value) {
      switch(
        action,
        MoveUp = self$y <- self$y + value,
        MoveDown = self$y <- self$y - value,
        MoveRight = self$x <- self$x + value,
        MoveLeft = self$x <- self$x - value
      )
    }
  )
)

result = input %>%
  group_by(Robot) %>%
  summarise(
    {
      rc <- get("Robot", envir = globalenv())
      r <- rc$new(Value[Action == "Start"])
      for (i in seq_along(Action)) {
        if (Action[i] != "Start") r$move(Action[i], as.numeric(Value[i]))
      }
      tibble(Final_X = r$x, Final_Y = r$y)
    },
    .groups = "drop"
  )

all.equal(result$Final_X, test$`Final X`) # True
all.equal(result$Final_Y, test$`Final Y`) # True
