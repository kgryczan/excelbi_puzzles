library(tidyverse)
library(readxl)

path <- "900-999/961/961 Monthly Rent Calculation.xlsx"
input <- read_excel(path, range = "A2:D22")
test <- read_excel(path, range = "F2:G25")

result <- input %>%
  rowwise() %>%
  mutate(
    start_date = as.Date(StartDate),
    end_date = as.Date(EndDate),
    rent = MonthlyRent,
    month_seq = list(
      seq(
        from = floor_date(start_date, "month"),
        to = ceiling_date(end_date, "month") - days(1),
        by = "month"
      )
    )
  ) %>%
  unnest(month_seq) %>%
  mutate(YearMonth = format(month_seq, "%Y-%m")) %>%
  group_by(YearMonth) %>%
  summarise(
    total_rent = sum(
      rent /
        days_in_month(month_seq) *
        pmin(
          days_in_month(month_seq),
          pmax(0, as.numeric(end_date - month_seq + 1)),
          pmax(0, as.numeric(month_seq + days_in_month(month_seq) - start_date))
        )
    ) %>%
      round(0),
    .groups = "drop"
  )

colnames(result) <- colnames(test)
all.equal(result, test, check.attributes = FALSE)
