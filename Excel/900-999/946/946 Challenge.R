library(tidyverse)
library(readxl)

path <- "900-999/946/946 Single Answer After Iteration.xlsx"
input <- read_excel(path, range = "A1:A10")
test <- read_excel(path, range = "B1:B10")

reduce_to_single = function(x) {
  numbers <- as.numeric(strsplit(x, ",")[[1]])
  vec = abs(diff(numbers))
  while (length(unique(vec)) > 1) {
    vec = abs(diff(vec))
  }
  return(vec[1])
}

result = input %>%
  mutate(res = map_dbl(Input, reduce_to_single))

all.equal(result$res, test$`Answer Expected`)
