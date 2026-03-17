library(tidyverse)
library(readxl)

path <- "300-399/320/320 Largest Sum.xlsx"
input <- read_excel(path, range = "A1:A10")
test <- read_excel(path, range = "C1:C2")

kadane <- function(x) {
  curr <- x[1]
  best <- x[1]
  for (n in x[-1]) {
    curr <- max(n, curr + n)
    best <- max(best, curr)
  }
  best
}

result <- tibble(`Answer Expected` = kadane(input$Numbers))

all.equal(result, test)
# [1] TRUE
