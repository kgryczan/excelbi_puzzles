library(tidyverse)
library(readxl)

path = "Power Query/300-399/334/PQ_Challenge_334.xlsx"
input = read_excel(path, range = "A1:C8")
test  = read_excel(path, range = "E1:H22")

result = input %>%
  fill(Year) %>%
  mutate(date = yq(paste0(Year, Quarter))) %>%
  rowwise() %>%
  mutate(month = list(seq(date, date + months(3) - days(1), by = "month"))) %>%
  unnest(month) %>%
  mutate(eom = ceiling_date(month, "month") - days(1),
         Value = Value / 3) %>%
  select(Year, `From Date` = month, `To Date` = eom, Value) %>%
  mutate(across(c(`From Date`, `To Date`), as.POSIXct))

all.equal(result, test, check.attributes = FALSE)
# [1] TRUE