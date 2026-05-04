library(tidyverse)
library(readxl)

path <- "900-999/969/969 Warmer Days Ahead.xlsx"
input <- read_excel(path, range = "A1:B21")
test <- read_excel(path, range = "C1:C21")

wait_warmer <- \(temp) {
  answer <- integer(length(temp))
  stack <- integer(0)
  for (today in rev(seq_along(temp))) {
    while (length(stack) && temp[stack[1]] <= temp[today]) {
      stack <- stack[-1]
    }
    if (length(stack)) {
      answer[today] <- stack[1] - today
    }
    stack <- c(today, stack)
  }
  answer
}

result = wait_warmer(input$Temperature)
all.equal(result, test$`Answer Expected`)
# [1] TRUE
