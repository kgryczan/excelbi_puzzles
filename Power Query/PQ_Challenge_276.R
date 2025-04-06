library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_276.xlsx"
input = read_excel(path, range = "A1:I4")
test  = read_excel(path, range = "A9:F18")

result = input %>%
  pivot_longer(cols = -c(1:3), names_to = c(".value", "index"), names_pattern = "([a-zA-Z]+)(\\d+)") %>%
  na.omit() %>%
  rename(Item = Item1) %>%
  mutate(`Total Value` = Qty * Price,
         across(c(`Order ID`, Qty, Price), as.character))

totals = result %>%a
  summarise(Shipping = first(Shipping),
            `Total Value` = sum(`Total Value`) + Shipping,
            .by = c(Item)) %>%

  mutate(`Order ID` = "TOTAL",
         index = NA, 
         Shipping  = NA,
         Qty = NA,
         Price = NA)

r2= result %>%
  bind_rows(totals) %>%
  arrange(Item) %>%
  mutate(Item = ifelse(`Order ID` == "TOTAL", NA, Item))

