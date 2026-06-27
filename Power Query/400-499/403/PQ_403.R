library(tidyverse)
library(readxl)

path <- "400-499/403/PQ_Challenge_403.xlsx"
input <- read_excel(path, range = "A1:D13")
test <- read_excel(path, range = "G1:K37")

last_friday <- \(y, m) {
  last_day <- as.Date(sprintf(
    "%04d-%02d-01",
    y + (m == 12),
    if_else(m == 12, 1, m + 1)
  )) -
    1

  last_day - ((as.POSIXlt(last_day)$wday - 5) %% 7)
}
input <- input %>%
  mutate(
    year = str_match(FiscalQuarter, "FY(\\d{4})-(Q\\d)")[, 2] %>% as.integer(),
    q = str_match(FiscalQuarter, "FY(\\d{4})-(Q\\d)")[, 3] %>% parse_number()
  )
result <- input %>%
  mutate(
    fiscal_month = map(q, ~ (.x - 1) * 3 + 2:4),
    weights = map(
      SplitPattern,
      ~ as.integer(str_split(as.character(.x), "")[[1]])
    )
  ) %>%
  unnest(c(fiscal_month, weights)) %>%
  mutate(
    cal_year = year + (fiscal_month > 12),
    month_no = ((fiscal_month - 1) %% 12) + 1,
    Month = paste0(cal_year, "-", str_pad(month_no, 2, pad = "0"), "-01") %>%
      as.Date() %>%
      as.POSIXct(),
    MonthlyAmount = round(Amounts * weights / 13),
    PostingDate = map2_vec(cal_year, month_no, last_friday) %>% as.POSIXct()
  ) %>%
  mutate(
    MonthlyAmount = MonthlyAmount +
      if_else(weights == 5, first(Amounts) - sum(MonthlyAmount), 0),
    .by = c(Division, FiscalQuarter)
  ) %>%
  select(Division, FiscalQuarter, Month, PostingDate, MonthlyAmount)

all.equal(result, test, check.attributes = FALSE)
