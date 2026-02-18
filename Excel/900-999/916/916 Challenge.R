library(tidyverse)
library(readxl)

path <- "Excel/900-999/916/916 Burrows - Wheeler Data Transform.xlsx"
input <- read_excel(path, range = "A1:A10")
test <- read_excel(path, range = "B1:B10")

bwt <- function(x) {
  n <- str_length(x)

  rotations <- map_chr(0:(n - 1), \(k) {
    str_c(str_sub(x, k + 1, n), str_sub(x, 1, k))
  })

  rotations %>%
    sort() %>%
    str_sub(-1) %>%
    str_c(collapse = "")
}

result = input %>%
  mutate(`Answer Expected` = map_chr(Words, bwt))

all.equal(result$`Answer Expected`, test$`Answer Expected`)
## [1] TRUE
