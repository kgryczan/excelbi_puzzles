library(tidyverse)
library(readxl)

path = "Excel/619 Top 3.xlsx"
input = read_excel(path, range = "A1:M10")
test  = read_excel(path, range = "A13:D18")

result = input %>%
  pivot_longer(-c(1), names_to = "month", values_to = "value") %>%
  mutate(month = match(month, month.abb),
         quarter = paste0("Q",ceiling(month / 3))) %>%
  summarise(value = sum(value), .by = c(quarter, Name)) %>%
  mutate(rank = dense_rank(desc(value)), .by = quarter) %>%
  filter(rank <= 3) %>%
  arrange(quarter, rank) %>%
  mutate(rn = row_number(), .by = quarter) %>%
  select(-c(rank, value)) %>%
  pivot_wider(names_from = quarter, values_from = Name) %>%
  select(-rn)
  
all.equal(result, test)
#> [1] TRUE