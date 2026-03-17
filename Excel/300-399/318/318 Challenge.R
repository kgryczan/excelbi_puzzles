library(tidyverse)
library(readxl)

path <- "300-399/318/318 Sum of Series.xlsx"
input <- read_excel(path, range = "A1:A10")
test  <- read_excel(path, range = "B1:B10")

result <- input |>
  mutate(`Expected Answer` = N * (N + 1) * (N + 2) * (N + 3) / 4)

all.equal(result$`Expected Answer`, test$`Expected Answer`)
# [1] TRUE
