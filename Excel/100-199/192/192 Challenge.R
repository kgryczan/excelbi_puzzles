library(tidyverse)
library(readxl)

path = "Excel/192 Year and Sum of Digits of Year.xlsx"
test  = read_excel(path, range = "A1:A3")

test_year = 2023
range = 1900:9999
sum_digits = function(x) sum(as.numeric(unlist(strsplit(as.character(x), ""))))

df = tibble(year = range, sum_digits = map_dbl(range, sum_digits)) %>%
  filter(year + sum_digits == test_year) %>%
  select(year)

all.equal(df$year, test$`Expected Answer`)
# [1] TRUE
