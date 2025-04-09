library(tidyverse)
library(readxl)

path = "Excel/208 Payment Made in all Quarters.xlsx"
input = read_excel(path, range = "A1:M10")
test  = read_excel(path, range = "O1:O5")

result = input %>%
  pivot_longer(cols = -1, names_to = "Month", values_to = "Amount") %>%
  mutate(quarter = case_when(
    Month %in% c("Jan", "Feb", "Mar") ~ "Q1",
    Month %in% c("Apr", "May", "Jun") ~ "Q2",
    Month %in% c("Jul", "Aug", "Sep") ~ "Q3",
    Month %in% c("Oct", "Nov", "Dec") ~ "Q4"
  )) %>%
  summarise(
    Amount = sum(Amount, na.rm = F),
    .by = c(Customer, quarter)
  ) %>%
  mutate(proper = all(Amount >= 1, na.rm = T), .by = Customer) %>%
  filter(proper) %>%
  select(Customer) %>%
  distinct() 

all.equal(result$Customer, test$`Answer Expected`)
#> [1] TRUE