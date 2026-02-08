library(tidyverse)
library(readxl)

path <- "Power Query/300-399/364/PQ_Challenge_364.xlsx"
input <- read_excel(path, range = "A1:A51")
test <- read_excel(path, range = "C1:F13")

result = input %>%
  separate_wider_delim(
    cols = `OrderID,OrderDate,Customer,Items`,
    delim = ",",
    names = c("OrderID", "OrderDate", "Customer", "Items")
  ) %>%
  separate_longer_delim("Items", delim = ";") %>%
  separate_wider_delim(
    "Items",
    delim = ":",
    names = c("Item", "Quantity", "Price")
  ) %>%
  mutate(
    Quarter = paste0("Q", quarter(OrderDate)),
    Sales = as.numeric(Quantity) * as.numeric(Price)
  ) %>%
  summarise(`Total Sales` = sum(Sales), .by = c(Customer, Quarter)) %>%
  mutate(Rank = dense_rank(-`Total Sales`), .by = Quarter) %>%
  filter(Rank <= 3) %>%
  arrange(Quarter, Rank) %>%
  select(Quarter, Customer, `Total Sales`, Rank)

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE
