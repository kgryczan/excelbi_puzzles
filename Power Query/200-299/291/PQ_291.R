library(tidyverse)
library(readxl)

path = "Power Query/200-299/291/PQ_Challenge_291.xlsx"
input = read_excel(path, range = "A1:D49")
test = read_excel(path, range = "F1:I29")

result = input %>%
  fill(Company, Target) %>%
  filter(cumsum(Sales) <= Target, .by = Company) %>%
  mutate(
    Company = ifelse(row_number() == 1, Company, NA),
    Target = ifelse(row_number() == 1, Target, NA),
    .by = Company
  )

all.equal(result, test, heck.attributes = FALSE)
# TRU
