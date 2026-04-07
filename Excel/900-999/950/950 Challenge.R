library(tidyverse)
library(readxl)

path <- "900-999/950/950 Containers Allotment.xlsx"
input <- read_excel(path, range = "A1:B21")
test <- read_excel(path, range = "C1:C21")

assign_container <- function(sizes, capacity = 100) {
  bins <- numeric()
  map_chr(sizes, function(x) {
    idx <- which(bins + x <= capacity)[1]
    if (is.na(idx)) {
      bins <<- c(bins, x)
      idx <- length(bins)
    } else {
      bins[idx] <<- bins[idx] + x
    }
    paste0("C", idx)
  })
}
result <- input %>%
  mutate(Container = assign_container(Size))

all.equal(result$Container, test$`Answer Expected`)
# [1] TRUE
