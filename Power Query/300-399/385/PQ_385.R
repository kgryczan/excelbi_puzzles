library(tidyverse)
library(readxl)
library(janitor)
library(lubridate)

path <- "300-399/385/PQ_Challenge_385.xlsx"
input <- read_excel(path, range = "A1:A25", col_names = FALSE)
test <- read_excel(path, range = "D1:F5")

parse_price <- \(x) {
  if_else(str_detect(x, "%"), parse_number(x) / 100, parse_number(x))
}

step <- \(x) {
  reduce(
    x,
    \(acc, v) {
      if (is.na(v)) {
        acc
      } else if (near(v, round(v))) {
        acc + v
      } else {
        acc + acc * v
      }
    },
    .init = 0
  )
}

result <-
  input %>%
  separate_wider_delim(
    ...1,
    ",",
    names = c("Product", "Date", "Type", "Price")
  ) %>%
  row_to_names(1) %>%
  mutate(Date = ymd(Date), Price = parse_price(Price)) %>%
  group_by(Product) %>%
  summarise(
    Date = last(Date) %>% as.POSIXct(),
    Price = {
      pos <- zoo::na.locf(match(Type, c("Base", "Override")), na.rm = FALSE)
      if (all(is.na(pos))) {
        NA_real_
      } else {
        step(Price[pos == max(pos, na.rm = TRUE)])
      }
    },
    .groups = "drop"
  )

all.equal(result, test, check.attributes = FALSE)
# [1] TRUE
