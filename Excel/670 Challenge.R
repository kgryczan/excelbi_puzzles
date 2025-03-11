library(tidyverse)
library(readxl)

path = "Excel/670 Transpose.xlsx"
input = read_excel(path, range = "A2:C11")
test  = read_excel(path, range = "E2:I5")

result = input %>%
  mutate(Year = ifelse(Classification == "Year", Detail, NA)) %>%
  fill(Year) %>%
  filter(Classification != "Year") %>%
  pivot_wider(names_from = Classification, values_from = Detail) %>%
  mutate(Profit = Revenue - Cost)

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE
