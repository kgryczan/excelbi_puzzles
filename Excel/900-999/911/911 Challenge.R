library(tidyverse)
library(readxl)
library(lubridate)

path <- "Excel/900-999/911/911 Billing Installments.xlsx"
input <- read_excel(path, range = "A2:E7")
test <- read_excel(path, range = "G2:I16")

result = input %>%
  mutate(
    intervals = interval(start = `Start Date`, end = `End Date`) %/%
      months(1) +
      1,
    period = case_when(
      `Billing Frequency` == "Monthly" ~ intervals,
      `Billing Frequency` == "Quarterly" ~ ceiling(intervals / 3),
      `Billing Frequency` == "Annually" ~ ceiling(intervals / 12),
      TRUE ~ NA_real_
    )
  ) %>%
  uncount(period, .remove = FALSE) %>%
  mutate(rn = row_number(), .by = `Client Name`) %>%
  mutate(
    mult = case_when(
      `Billing Frequency` == "Monthly" ~ 1,
      `Billing Frequency` == "Quarterly" ~ 3,
      `Billing Frequency` == "Annually" ~ 12,
      TRUE ~ NA_real_
    )
  ) %>%
  mutate(
    `Billing Date` = ceiling_date(`Start Date`, unit = "month") %m+%
      months(rn * mult) -
      days(1)
  ) %>%
  mutate(`Installment Amount` = Amount / period) %>%
  select(`Client Name`, `Billing Date`, `Installment Amount`)

all.equal(result, test)
#> [1] TRUE
