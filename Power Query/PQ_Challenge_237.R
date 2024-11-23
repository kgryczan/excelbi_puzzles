library(tidyverse)
library(readxl)
library(glue)

path = "Power Query/PQ_Challenge_237.xlsx"
input = read_excel(path, range = "A1:E11")
test  = read_excel(path, range = "G1:K11")

result = input %>%
  mutate(across(everything(), ~ {
    empty_index = row_number()[is.na(.)]
    ifelse(is.na(.),
           glue("{cur_column()}_{match(row_number(), empty_index)}"),
           as.character(.))}))

all.equal(result, test, check.attributes = FALSE)
# [1] TRUE