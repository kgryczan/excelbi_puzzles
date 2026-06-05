library(tidyverse)
library(readxl)

path <- "900-999/993/993 Pivot.xlsx"
input <- read_excel(path, range = "A1:A21")
test <- read_excel(path, range = "C2:D8")

priority_w <- c(H = .5, M = .3, L = .1)
channel_w <- c(E = .4, P = .2, C = .1)
currency_fx <- c(USD = 94, EUR = 130, INR = 1)

result <- input %>%
  mutate(
    City = str_match(Data, "LOC\\(([^)]+)\\)")[, 2],
    Currency = str_match(Data, "TX\\{[^|]+\\|([^|]+)\\|")[, 2],
    Amount = as.numeric(str_match(Data, "TX\\{[^|]+\\|[^|]+\\|([^|]+)\\|")[,
      2
    ]),
    Priority = str_match(Data, "P:([^/]+)")[, 2],
    Channel = str_match(Data, "C:([^/]+)")[, 2],
    Weighted = Amount *
      currency_fx[Currency] *
      (coalesce(priority_w[Priority], 0) + coalesce(channel_w[Channel], 0))
  ) %>%
  summarise(
    `Weighted Total (INR)` = sum(Weighted),
    .by = City
  ) %>%
  arrange(City)

result == test
# One value is different.
