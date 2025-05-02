library(tidyverse)
library(readxl)

path = "Excel/493 Start End Indexes for a Particular Sum.xlsx"

input = read_excel(path, range = "A2:B21")
test  = read_excel(path, range = "D2:F9")

result = input %>%
  mutate(group = accumulate(Number, ~{if(.x + .y > 100) .y else .x + .y}),
         group = cumsum(group == Number)) %>%
  summarise(`Start Index` = min(Index), `End Index` = max(Index), Sum = sum(Number), .by = group) %>%
  select(`Start Index` , `End Index`, Sum)

identical(result, test)
# [1] TRUE
