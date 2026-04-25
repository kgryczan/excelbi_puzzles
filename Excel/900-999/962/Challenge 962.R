library(tidyverse)
library(readxl)

path <- "900-999/962/962 Recuce Till Single Digit Htrough Multiplication.xlsx"
input <- read_excel(path, range = "A2:A10")
test <- read_excel(path, range = "B2:C10")

multiply_digits <- function(x) {
  digits <- as.integer(strsplit(as.character(x), "")[[1]])
  prod(digits)
}
persistence <- function(x) {
  count <- 0
  while (x >= 10) {
    x <- multiply_digits(x)
    count <- count + 1
  }
  list(Persistence = count, `Final Digit` = x)
}
results <- input %>%
  rowwise() %>%
  mutate(result = list(persistence(Number))) %>%
  unnest_wider(result)

all.equal(results %>% select(-Number), test)
# True
