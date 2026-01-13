library(tidyverse)
library(readxl)

path <- "Excel/800-899/889/889 CYTD Commission Calculation.xlsx"
input <- read_excel(path, range = "A1:C21")
test <- read_excel(path, range = "D1:D21")

result = input %>%
  mutate(year = year(Date)) %>%
  mutate(CumsumSales = cumsum(Sale_Amount), .by = c(Sales_Rep, year)) %>%
  mutate(
    cum_comm = pmin(CumsumSales, 10000) *
      0.05 +
      pmax(pmin(CumsumSales - 10000, 10000), 0) * 0.10 +
      pmax(CumsumSales - 20000, 0) * 0.15
  ) %>%
  mutate(
    tier_comm = cum_comm - lag(cum_comm, default = 0),
    .by = c(Sales_Rep, year)
  )

all.equal(result$tier_comm, test$`Answer Expected`, check.attributes = FALSE)
# [1] TRUE
