library(tidyverse)
library(readxl)

path = "Excel/707 Split at Non Alphabetic Delimiters.xlsx"
input = read_excel(path, range = "A1:A10")
test = read_excel(path, range = "B1:B36")

result = input %>%
  separate_rows(Sentences, sep = "[^[:alpha:]]+")

all.equal(result$Sentences, test$`Expected Answer`)
#> [1] TRUE
