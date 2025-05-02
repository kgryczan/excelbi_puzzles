library(tidyverse)
library(readxl)

path = "Excel/679 Last Item to be Selected.xlsx"
input = read_excel(path, range = "A2:D19")
test  = read_excel(path, range = "F2:G6")
 
last_item <- function(data) {
  N <- as.numeric(data[1])
  items <- na.omit(data[-1])
  front <- TRUE
  
  while (length(items) > N) {
    items <- if (front) items[(N + 1):length(items)] else items[1:(length(items) - N)]
    front <- !front
  }
  
  items[length(items)]
}

result = data.frame(
  Run = names(input),
  items = map_chr(input, last_item)
)

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE