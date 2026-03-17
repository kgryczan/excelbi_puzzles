library(tidyverse)
library(readxl)

path <- "300-399/313/313 Scan3.xlsx"
input <- read_excel(
  path,
  range = "A2:G5",
  col_names = FALSE,
  col_types = "text"
)
test <- read_excel(path, range = "I2:O5", col_names = FALSE, col_types = "text")

result <- as.data.frame(t(apply(input, 1, function(row) {
  sapply(0:6, function(k) {
    paste(row[seq(k %% 2 + 1, k + 1, by = 2)], collapse = "")
  })
})))

all.equal(unname(result), unname(test))
# [1] TRUE
