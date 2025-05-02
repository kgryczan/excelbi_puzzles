library(tidyverse)
library(readxl)

path = "Excel/695 Broadcast Calendar.xlsx"
test = read_excel(path, range = "A2:E54")

monday_of_isoweek <- function(year, week) {
  ISOdate(year, 1, 4) +
    weeks(week - 1) -
    days(wday(ISOdate(year, 1, 4), week_start = 1) - 1)
}

result = data.frame(
  From = monday_of_isoweek(2025, 1:52),
  To = monday_of_isoweek(2025, 1:52) + days(6),
  Week = 1:52
) %>%
  mutate(Month = month(To, label = TRUE, abbr = TRUE, locale = "en")) %>%
  mutate(month_week = row_number(), .by = Month) %>%
  mutate(From = format(From, "%Y-%m-%d"), To = format(To, "%Y-%m-%d")) %>%
  select(
    Month,
    `Month Week` = month_week,
    `Year Week` = Week,
    `From Date` = From,
    `To Date` = To
  )
