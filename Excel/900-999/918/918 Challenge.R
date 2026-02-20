library(tidyverse)
library(readxl)

path <- "Excel/900-999/918/918 Extract Data.xlsx"
input <- read_excel(path, range = "B1:B1", col_names = FALSE)
test <- read_excel(path, range = "A3:C13")

R <- function(pattern) str_extract_all(input %>% pull(), pattern)[[1]]

result = tibble(
  `Ref Number` = R("REF-\\d{4}"),
  `E Mail ID` = R("[\\w.-]+@[\\w.-]+"),
  `Website Address` = R("(www\\.|https?://)[\\w./-]*[\\w/-]")
)

all(test == result)
## [1] TRUE
