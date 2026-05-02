library(tidyverse)
library(readxl)

path <- "300-399/387/PQ_Challenge_387.xlsx"
input <- read_excel(path, range = "A1:A16")
test <- read_excel(path, range = "C1:G6")

result = input %>%
  separate_wider_delim(
    col = 1,
    delim = " | ",
    names = c("order", "priority", "items", "discount"),
    too_few = "align_start"
  ) %>%
  mutate(
    priority = str_extract(priority, "(?<=Priority:)[A-Za-z]+"),
    items = str_extract_all(items, "(?<=\\[).+?(?=\\])")
  ) %>%
  unnest_longer(items) %>%
  separate_wider_delim(
    items,
    delim = ":",
    names = c("SKU", "quantity", "unit_price")
  ) %>%
  mutate(
    discount = coalesce((str_extract(discount, "\\d+") %>% as.numeric()), 0),
    quantity = as.numeric(quantity),
    unit_price = as.numeric(unit_price),
    total_price = quantity * unit_price * (1 - discount / 100)
  ) %>%
  summarise(Sales = round(sum(total_price), 2), .by = c(SKU, priority)) %>%
  pivot_wider(names_from = priority, values_from = Sales, values_fill = 0) %>%
  select(SKU, High, Medium, Low) %>%
  arrange(SKU) %>%
  janitor::adorn_totals("col")

all.equal(result, test, check.attributes = FALSE)
# small rounding dicrepancy in High priority, but otherwise matches the expected result
