library(tidyverse)
library(readxl)
library(stringdist)

path <- "900-999/973/973 Minimum Edits.xlsx"
input <- read_excel(path, range = "A1:A14")
test <- read_excel(path, range = "B1:B14")

result = input %>%
  separate_wider_delim(
    col = "Pair",
    delim = " | ",
    names = c("String1", "String2")
  ) %>%
  mutate(Edits = stringdist(String1, String2, method = "lv"))

all.equal(result$Edits, test$`Answer Expected`)
# [1] TRUE
