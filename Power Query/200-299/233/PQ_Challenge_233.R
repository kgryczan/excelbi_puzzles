library(tidyverse)
library(readxl)
library(janitor)

path = "Power Query/PQ_Challenge_233.xlsx"
input = read_excel(path, range = "A1:G7")
test  = read_excel(path, range = "A13:H16")

result = input %>%
  pivot_longer(-c(1), names_to = c(".value", "number"), names_pattern = "([A-Za-z]+)(\\d)") %>%
  mutate(amount = Price * Quantity) %>%
  summarise(amount = sum(amount), .by = c("Fruits", "Shipped")) %>% 
  mutate(Status = recode(Shipped, "Y" = "Shipped Amount", "N" = "Not Shipped Amount")) %>%
  select(-Shipped) %>%
  pivot_wider(names_from = Fruits, values_from = amount, values_fill = 0) %>%
  adorn_totals("both") %>%
  select(Status, Apple, Banana, Papaya, Mango, Pineapple, Kiwi, Total)

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE