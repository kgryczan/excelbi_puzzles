library(tidyverse)
library(readxl)

path <- "900-999/994/994 Housing Prices.xlsx"
input <- read_excel(path, range = "A2:D24")
test <- read_excel(path, range = "F2:G7")

result <- input %>%
  summarise(
    Volatility = max(Price) - min(Price),
    Latest_Price = median(Price[ListDate == max(ListDate)]),
    .by = City
  ) %>%
  mutate(
    Adjustment = case_when(
      Volatility >= 1e6 ~ 0.02,
      Volatility >= 5e5 ~ 0.01,
      TRUE ~ 0
    ),
    FinalMarketPrice = Latest_Price * (1 - Adjustment)
  ) %>%
  select(City, FinalMarketPrice) %>%
  arrange(City)

all.equal(result, test)
#> [1] TRUE
