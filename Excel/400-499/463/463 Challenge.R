library(tidyverse)
library(readxl)
library(padr)

input = read_excel("Excel/463 Inventory Calculation.xlsx", range = "A1:C6") %>% janitor::clean_names()
test  = read_excel("Excel/463 Inventory Calculation.xlsx", range = "E2:F14") %>% janitor::clean_names()

months = tibble(abbs = month.abb, month = 1:12)

result = months %>%
  left_join(input, by = c("abbs" = "month")) %>%
  replace_na(list(incoming_qty = 0, outgoing_qty = 0)) %>%
  mutate(inventory = accumulate2(incoming_qty, outgoing_qty, .init = 0, 
                                .f = ~ ..1 + ..2 - ..3)[-1]) %>%
  select(month = abbs, inventory)

identical(result, test)
# [1] TRUE