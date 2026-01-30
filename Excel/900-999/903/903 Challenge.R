library(tidyverse)
library(readxl)

path <- "Excel/900-999/903/903 All Numbers in the Range.xlsx"
input <- read_excel(path, range = "A1:A11")
test <- read_excel(path, range = "B1:B6")

funA = function(string) {
  x = str_split(string, pattern = ", ")[[1]]
  x = unlist(map(x, function(element) {
    if (str_detect(element, "-")) {
      range = as.numeric(str_split(element, "-")[[1]])
      return(seq(range[1], range[2], by = 1))
    } else {
      return(as.numeric(element))
    }
  }))
  max_x <- max(x)
  min_x <- min(x)
  full_seq = seq(min_x, max_x, 1)
  return(all(full_seq %in% x))
}

output <- input %>%
  rowwise() %>%
  mutate(Result = funA(Data)) %>%
  filter(Result)

all.equal(output$Data, test$`Answer Expected`)
# [1] TRUE
