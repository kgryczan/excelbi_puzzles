library(tidyverse)
library(readxl)
library(rlang)

path <- "Power Query/300-399/358/PQ_Challenge_358.xlsx"
input <- read_excel(path, range = "A1:E21")
test <- read_excel(path, range = "G1:H10")

prices = input %>%
  select(Price) %>%
  separate_longer_delim(Price, delim = ";") %>%
  separate_wider_delim(Price, delim = "=", names = c("Code", "Price")) %>%
  distinct() %>%
  arrange(Code)

orders = input %>%
  select(OrderID, Customer, Items) %>%
  separate_longer_delim(Items, delim = ";") %>%
  mutate(
    Outside = if_else(
      str_detect(Items, "\\[.*\\]"),
      str_remove(Items, "\\[.*\\]"),
      NA_character_
    ),
    Inside = if_else(
      str_detect(Items, "\\[.*\\]"),
      str_extract(Items, "\\[.*\\]"),
      Items
    )
  ) %>%
  mutate(Inside = str_remove_all(Inside, "[\\[\\]]")) %>%
  separate_longer_delim(Inside, delim = "+") %>%
  separate_wider_delim(Inside, delim = "*", names = c("Code", "Quantity"))

result = input %>%
  select(OrderID, Customer, DiscountCode) %>%
  left_join(orders, by = c("OrderID", "Customer")) %>%
  left_join(prices, by = c("Code")) %>%
  mutate(Amount = as.numeric(Quantity) * as.numeric(Price)) %>%
  select(-c(Price, Quantity, Code)) %>%
  mutate(
    discount = case_when(
      DiscountCode == "DISC5" ~ 0.05,
      DiscountCode == "DISC10" ~ 0.1,
      TRUE ~ 0
    ),
    all_discount = case_when(
      Outside == "BNDL" ~ 1 - discount - 0.1,
      Outside == "RET" ~ -1,
      Outside == "NONE" ~ 1 - discount,
      Outside == "FREE" ~ 0,
      TRUE ~ 1 - discount
    )
  ) %>%
  mutate(Total = Amount * all_discount) %>%
  group_by(Customer) %>%
  summarise(Total = sum(Total, na.rm = TRUE))

all.equal(result, test, check.attributes = FALSE)
# One difference
