library(tidyverse)
library(readxl)

path <- "Power Query/300-399/366/PQ_Challenge_366.xlsx"
input <- read_excel(path, range = "A1:B46")
test <- read_excel(path, range = "D1:J11")

result <- input %>%
  mutate(
    order_grp = cumsum(Attribute == "Order ID")
  ) %>%
  group_by(order_grp) %>%
  mutate(
    sub_id = cumsum(Attribute == "Customer")
  ) %>%
  ungroup() %>%
  group_by(order_grp, sub_id, Attribute) %>%
  fill(Value, .direction = "down") %>%
  ungroup() %>%
  pivot_wider(
    id_cols = c(order_grp, sub_id),
    names_from = Attribute,
    values_from = Value
  ) %>%
  arrange(order_grp, sub_id) %>%
  select(
    `Order ID`,
    `Sub Order ID` = sub_id,
    Customer,
    Date,
    Region,
    Priority,
    Status
  ) %>%
  fill(`Order ID`, .direction = "down") %>%
  filter(`Sub Order ID` != 0) %>%
  mutate(
    Date = janitor::excel_numeric_to_date(as.numeric(Date)) %>%
      as.POSIXct(origin = "1970-01-01", tz = "UTC")
  )

all.equal(result, test, check.attributes = FALSE)
# Sub Order ID in ORD-105 should be 1 not 2.
