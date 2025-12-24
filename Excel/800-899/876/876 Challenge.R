library(tidyverse)
library(readxl)

path <- "Excel/800-899/876/876 Running Total.xlsx"
input <- read_excel(path, range = "A1:B41")
test <- read_excel(path, range = "C1:C41")


result = input %>%
  mutate(streak = cumsum(Value != lag(Value, default = first(Value)))) %>%
  mutate(n = row_number(), .by = streak) %>%
  mutate(
    adj = if_else(Value %% 2 == 0, Value - 2 * (n - 1), Value + (n - 1)),
    running_total = cumsum(adj)
  )

all.equal(result$running_total, test$`Answer Expected`)
# [1] TRUE
