library(tidyverse)
library(readxl)
library(lubridate)

path <- "Excel/800-899/892/892 Quarterly Running Total.xlsx"
input <- read_excel(path, range = "A2:D50")
test <- read_excel(path, range = "E2:F50")

result = input %>%
  mutate(
    Quarter = paste0("Q", ceiling(month(as.Date(Date)) / 3)),
    amount = Credit + Interest - Debit
  ) %>%
  mutate(RunningTotal = cumsum(amount), .by = Quarter) %>%
  select(Quarter, RunningTotal)

all.equal(test, result)
# [1] TRUE
