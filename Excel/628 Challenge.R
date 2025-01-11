library(tidyverse)
library(readxl)

path = "Excel/628 Bottle Price Optimization.xlsx"
input1 = read_excel(path, range = "A1:C6") %>% janitor::clean_names()
input2 = read_excel(path, range = "A8:A12") 
test  = read_excel(path, range = "A8:B12")

df = expand_grid(A = 0:10, B = 0:10, C = 0:10, D = 0:10, E = 0:10) %>%
  mutate(rn = row_number()) %>% 
  pivot_longer(-rn, names_to = "capacity", values_to = "value") %>%
  left_join(input1, by = c("capacity" = "bottle_type"), keep = T) %>%
  mutate(cost = value * cost_bottle,
         capacity = value * capacity_l) %>%
  filter(capacity != 0) %>%
  mutate(combo = paste0(value, "x", bottle_type)) %>%
  summarise(total_cost = sum(cost),
            total_capacity = sum(capacity),
            combo = paste0(combo, collapse = ", "), 
            .by = rn)
  
total = input2 %>%
  left_join(df, by = c("Input Litres" = "total_capacity")) %>%
  mutate(lower_cost = min(total_cost, na.rm = T), .by = `Input Litres`) %>%
  filter(total_cost == lower_cost)

all.equal(total$total_cost, test$`Answer Expected`, check.attributes = F)
# [1] TRUE