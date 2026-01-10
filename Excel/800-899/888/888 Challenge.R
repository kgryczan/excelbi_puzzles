library(tidyverse)
library(readxl)

path <- "Excel/800-899/888/888 Jolly Sequence.xlsx"
input <- read_excel(path, range = "A1:A21")
test <- read_excel(path, range = "B1:B21")

jolly_check <- function(a) {
  x <- as.integer(str_split(a, ",")[[1]])
  all(sort(unique(abs(diff(x)))) == seq_along(x)[-1])
}
result <- input %>%
  rowwise() %>%
  mutate(
    Jolly = jolly_check(`Input String`),
    `Answer Expected` = ifelse(Jolly, "Jolly", "Not jolly")
  )
all.equal(
  result$`Answer Expected`,
  test$`Answer Expected`,
  check.attributes = FALSE
)
# [1] TRUE
