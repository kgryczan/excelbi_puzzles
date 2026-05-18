library(tidyverse)
library(readxl)

path <- "900-999/979/979 Split and Categorize.xlsx"
input <- read_excel(path, range = "A2:B11")
test <- read_excel(path, range = "D2:F16")

result = input %>%
  separate_rows(Items, sep = ", ") %>%
  transmute(
    Category = if_else(row_number() == 1, Category, NA_character_),
    `All Items` = if_else(
      row_number() == 1,
      paste(Items, collapse = ", "),
      NA_character_
    ),
    `Individual Items` = Items,
    .by = Category
  )

all.equal(result, test)
## [1] TRUE
