library(tidyverse)
library(readxl)

path <- "Power Query/300-399/368/PQ_Challenge_368.xlsx"
input <- read_excel(path, range = "A1:C23")
test <- read_excel(path, range = "E1:F6")

result = input %>%
  separate_wider_delim(
    cols = Transaction_Info,
    delim = "|",
    names = c("Company", "Type", "Detail", "Time")
  ) %>%
  separate_wider_delim(
    cols = Fee_Info,
    delim = ";",
    names = c("Leverage", "Fee")
  ) %>%
  separate_wider_delim(
    cols = Detail,
    delim = "@",
    names = c("Quantity", "Price")
  ) %>%
  mutate(
    Leverage = str_extract(Leverage, "\\d+") %>% as.numeric(),
    Fee = as.numeric(str_remove(str_extract(Fee, "\\d+\\.?\\d*%"), "%")),
    Price = as.numeric(Price),
    Quantity = as.numeric(Quantity)
  ) %>%
  mutate(
    Trade_value = Price * Quantity,
    Eff_trade_value = Trade_value * Leverage,
    Fee = Eff_trade_value * Fee / 100,
    Net_trade_value = Trade_value + (Fee * if_else(Type == "BUY", -1, 1))
  ) %>%
  summarise(
    `Net Trade Value` = round(sum(Net_trade_value, na.rm = TRUE), 0),
    .by = Trader_ID
  ) %>%
  janitor::adorn_totals(where = "row")

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE
