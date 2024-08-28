library(charcuterie)
library(tidyverse)
library(readxl)

path = "Excel/531 Numbers Divisible after Removing a Digit.xlsx"
test = read_excel(path, range = "A2:B502")

transform_number <- function(number) {
  num_str <- as.character(number)
  num_split <- chars(num_str)
  len <- length(num_split)
  result <- character(len)
  for (i in seq_along(num_split)) {
    result[i] <- paste0(num_split[-i], collapse = "")
  }
  result <- paste(result, collapse = ", ")
  return(result)
}

transform_number <- Vectorize(transform_number)
numbers <- data.frame(number = 101:1000000) %>%
  filter(number %% 10 != 0)

n1 = numbers %>%
  mutate(new_number = map_chr(number, transform_number)) %>%
  separate_rows(new_number, sep = ", ") %>%
  distinct() %>%
  mutate(new_number = as.numeric(new_number)) %>%
  filter(number %% new_number == 0, new_number != 1) %>%
  summarise(divisors = paste(new_number, collapse = ", "), .by = "number") %>%
  head(500)

all.equal(n1,  test, check.attributes = FALSE) 
#> [1] TRUE
