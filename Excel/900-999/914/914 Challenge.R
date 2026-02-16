library(tidyverse)
library(readxl)
library(lubridate)

path <- "Excel/900-999/914/914 Billing Amount.xlsx"
input <- read_excel(path, range = "A2:D13")
test <- read_excel(path, range = "F2:G4")

overlap <- function(a1, a2, b1, b2) {
  pmax(as.numeric(pmin(a2, b2) - pmax(a1, b1), "hours"), 0)
}
result = input %>%
  mutate(Date = as.Date(Date, tryFormats = c("%d.%m.%Y", "%Y-%m-%d"))) %>%
  separate_rows(Time, sep = ",") %>%
  separate(Time, c("s", "e"), "-") %>%
  mutate(
    s = ymd_hm(paste(Date, s)),
    e = ymd_hm(paste(Date, e)),
    d1 = ymd_hm(paste(Date, "09:00")),
    d2 = ymd_hm(paste(Date, "17:00")),
    tot = as.numeric(difftime(e, s, units = "hours")),
    reg = overlap(s, e, d1, d2),
    ot = tot - reg,
    amt = if_else(
      wday(Date, week_start = 1) >= 6,
      tot * Rate * 1.5,
      reg * Rate + ot * Rate * 1.2
    )
  ) %>%
  summarise(`Billed Amount` = sum(amt), .by = Resource)

all.equal(result, test)
# > [1] TRUE
