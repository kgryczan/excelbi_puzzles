library(tidyverse)
library(readxl)
library(lubridate)

path <- "Excel/800-899/886/886 Invoice Due Date Calculation.xlsx"
input <- read_excel(path, range = "A1:D40")
test <- read_excel(path, range = "E1:E40")

pay_cat = list(A = 30, B = 45, C = 60)
time_range = seq(ymd('2025-02-01'), ymd('2026-05-01'), by = '1 month')

adjust_due_date <- function(due_date) {
  case_when(
    wday(due_date) == 7 ~ due_date + days(2),
    wday(due_date) == 1 ~ due_date + days(1),
    TRUE ~ due_date
  )
}
input2 <- input %>%
  mutate(
    Due_date = case_when(
      Category == 'A' ~ Invoice_Date + days(pay_cat$A),
      Category == 'B' ~ Invoice_Date + days(pay_cat$B),
      Category == 'C' ~ Invoice_Date + days(pay_cat$C),
      TRUE ~ as.Date(NA)
    )
  ) %>%
  mutate(Due_date = adjust_due_date(Due_date))

repeat {
  input2 <- input2 %>%
    mutate(Due_month = floor_date(Due_date, unit = 'month')) %>%
    group_by(Due_month, Category) %>%
    arrange(Due_month, Category, Due_date, Invoice_Date) %>%
    mutate(row_num = row_number()) %>%
    ungroup() %>%
    mutate(
      Due_date_new = if_else(
        row_num <= 2,
        Due_date,
        adjust_due_date(ceiling_date(Due_date, unit = 'month'))
      )
    )

  if (all(input2$Due_date == input2$Due_date_new, na.rm = TRUE)) {
    break
  }
  input2$Due_date <- input2$Due_date_new
}

output <- input2 %>%
  select(-Due_date_new, -row_num, -Due_month) %>%
  arrange(Invoice_ID)

all.equal(output$Due_date, test$`Answer Expected`)
# I was defeated. My Logic doesn't cover all cases.
# Will not try with Python.
