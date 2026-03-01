library(tidyverse)
library(readxl)

path <- "Power Query/300-399/370/PQ_Challenge_370.xlsx"
input <- read_excel(path, range = "A1:D21")
test <- read_excel(path, range = "F1:K21")

start_date <- as.Date("2024-01-01")

result <- input %>%
  group_by(Department) %>%
  arrange(`Referral Date`, `Patient ID`) %>%
  mutate(
    position = row_number(),
    `Forecasted Month` = ceiling(position / 2),
    days_since_start = as.numeric(difftime(
      `Referral Date`,
      start_date,
      units = "days"
    )),
    referral_period = floor(days_since_start / 30) + 1,
    treatment_day = case_when(
      `Forecasted Month` == 1 ~ days_since_start,
      referral_period < `Forecasted Month` &
        referral_period == 1 ~ (`Forecasted Month` - 1) * 30 - 1,
      referral_period < `Forecasted Month` &
        referral_period >= 2 ~ (`Forecasted Month` - 1) * 30,
      referral_period == `Forecasted Month` ~ days_since_start,
      TRUE ~ (`Forecasted Month` - 1) * 30
    ),
    `Wait Days` = treatment_day - days_since_start,
    `SLA Status` = ifelse(
      `Wait Days` > `Target Days (SLA)`,
      "Breach",
      "Within SLA"
    )
  ) %>%
  ungroup() %>%
  select(
    `Patient ID`,
    Department,
    `Referral Date`,
    `Forecasted Month`,
    `Wait Days`,
    `SLA Status`
  ) %>%
  arrange(Department, `Referral Date`, `Patient ID`)

all.equal(result, test)
