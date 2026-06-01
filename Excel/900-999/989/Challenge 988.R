library(tidyverse)
library(readxl)

path <- "900-999/989/989 Chain Calculation.xlsx"
input <- read_excel(path, range = "A2:C26")
test <- read_excel(path, range = "E2:H5")

result = input %>%
  mutate(
    Time_diff = as.numeric(difftime(Timestamp, lag(Timestamp), units = "mins")),
    Chain = cumsum(ifelse(is.na(Time_diff) | Time_diff > 10, 1, 0)),
    .by = User
  ) %>%
  summarise(
    `Chain Start` = min(Timestamp),
    `Chain End` = max(Timestamp),
    `Chain Total Value` = sum(Value),
    .by = c(User, Chain)
  ) %>%
  slice_max(`Chain Total Value`, n = 1, by = User) %>%
  select(-Chain)

all.equal(result, test)
#> [1] TRUE
