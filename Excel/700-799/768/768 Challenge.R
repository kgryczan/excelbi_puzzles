library(tidyverse)
library(readxl)

path = "Excel/700-799/768/768 Cumulative Total Positive and Negative.xlsx"
input = read_excel(path, range = "A2:A19")
test  = read_excel(path, range = "B2:C19")

result = input %>%
  mutate(cs = cumsum(Numbers)) %>%
  transmute(
    Positive = if_else(cs > 0, cs, NA_real_),
    Negative = if_else(cs < 0, cs, NA_real_)
  )

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE