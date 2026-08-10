library(tidyverse)
library(readxl)

path <- "1000-1099/1039/1039 Asteroids Collision.xlsx"
input <- read_excel(path, range = "A1:A21")
test <- read_excel(path, range = "B1:B21") %>%
  mutate(
    `Answer Expected` = ifelse(is.na(`Answer Expected`), "", `Answer Expected`)
  )

survive <- function(values) {
  reduce(
    as.numeric(str_split(values, ",")[[1]]),
    function(stack, asteroid) {
      while (length(stack) && last(stack) > 0 && asteroid < 0) {
        if (abs(last(stack)) < abs(asteroid)) {
          stack <- head(stack, -1)
          next
        }
        if (abs(last(stack)) == abs(asteroid)) {
          stack <- head(stack, -1)
        }
        asteroid <- NA
        break
      }
      if (!is.na(asteroid)) c(stack, asteroid) else stack
    },
    .init = numeric()
  ) %>%
    paste(collapse = ",")
}

result <- map_chr(input$Asteroids, survive)
all.equal(test$`Answer Expected`, result)
# one entry in test is incorrect
