library(tidyverse)
library(readxl)
library(tictoc)

path = "Excel/499 Lynch Bell Numbers.xlsx"
test = read_excel(path, range = "A1:A501")


contains_zero <- function(number) {
  any(strsplit(number, "")[[1]] == "0")
}

has_unique_digits <- function(number) {
  digits <- strsplit(number, "")[[1]]
  length(unique(digits)) == length(digits)
}

is_self_dividing <- function(number) {
  digits <- as.numeric(strsplit(number, "")[[1]])
  all(digits != 0 & as.numeric(number) %% digits == 0)
}

get_numbers <- function(number_of_digits) {
  start <- 10^(number_of_digits - 1)
  end <- 10^number_of_digits - 1
  range <- as.character(start:end)
  
  result <- range %>%
    keep(~ !contains_zero(.x) && has_unique_digits(.x) && is_self_dividing(.x))
  
  return(tibble(number = result))
}

tic()
result = map_dfr(2:7, ~ get_numbers(.x)) %>% head(500)
toc()


identical(as.numeric(result$number), test$`Answer Expected`)
#> [1] TRUE