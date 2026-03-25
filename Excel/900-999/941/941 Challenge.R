library(tidyverse)
library(readxl)
library(lubridate)

path <- "900-999/941/941 Prorate Amount.xlsx"
input <- read_excel(path, range = "A2:D22")
test <- read_excel(path, range = "F2:L6")

result <- input |>
  mutate(
    Start_Date = as_date(Start_Date),
    End_Date = as_date(End_Date),
    daily_rate = Amount / (as.numeric(End_Date - Start_Date) + 1),
    date = map2(Start_Date, End_Date, ~ seq(.x, .y, by = "day"))
  ) |>
  select(Org, daily_rate, date) |>
  unnest(date) |>
  mutate(month_num = month(date)) |>
  summarise(monthly_amount = sum(daily_rate), .by = c(Org, month_num)) |>
  filter(month_num %in% 1:6) |>
  mutate(month = factor(month_num, levels = 1:6, labels = month.abb[1:6])) |>
  select(-month_num) |>
  pivot_wider(
    names_from = month,
    values_from = monthly_amount,
    values_fill = 0
  ) |>
  arrange(Org)

all.equal(result, test)
#> [1] TRUE
