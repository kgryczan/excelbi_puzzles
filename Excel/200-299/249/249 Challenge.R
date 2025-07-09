library(tidyverse)
library(readxl)

path = "Excel/200-299/249/249 Mulitply Till a Single Digit.xlsx"
input = read_excel(path, range = "A1:A9")
test  = read_excel(path, range = "B1:B9")

reduce_to_digit <- function(n) {
  while (n > 9) {
    n <- as.integer(
      str_replace_all(
        as.character(reduce(as.integer(str_split(as.character(n), "")[[1]]), `*`)),
        "0", "1"
      )
    )
  }
  n
}

result = input %>%
  mutate(result = map_int(Number, reduce_to_digit)) 
