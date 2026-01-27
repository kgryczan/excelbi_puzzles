library(tidyverse)
library(readxl)

path <- "Excel/900-999/900/900 Sales Larger than Quarterly Average.xlsx"
input <- read_excel(path, range = "A2:C52")
test <- read_excel(path, range = "E2:F8")

result = input %>%
  mutate(
    quarter = quarter(Date),
    Month = month(Date, label = T, abbr = T, locale = "en_US")
  ) %>%
  mutate(quarterly_avg = ave(Sales, quarter, FUN = mean)) %>%
  mutate(valid = ifelse(Sales > quarterly_avg, 1, 0)) %>%
  summarise(spvalid = sum(valid) == n(), .by = c(Month, Salesperson)) %>%
  filter(spvalid) %>%
  summarise(Names = paste(Salesperson, collapse = ", "), .by = Month) %>%
  complete(Month, fill = list(Names = NA)) %>%
  head(6) %>%
  mutate(Month = as.character(Month))

all.equal(result, test)
# [1] TRUE
