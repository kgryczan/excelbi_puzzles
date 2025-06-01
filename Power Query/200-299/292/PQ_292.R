library(tidyverse)
library(readxl)

path = "Power Query/200-299/292/PQ_Challenge_292.xlsx"
input = read_excel(path, range = "A1:K4")
test = read_excel(path, range = "A8:F14")

input2 = input %>%
  pivot_longer(cols = -c(1, 2)) %>%
  separate(name, into = c("name", "Item"), sep = "-") %>%
  fill(Item) %>%
  mutate(name = str_remove(name, "\.{3}\d{1,2}")) %>%
  pivot_wider(
    names_from = name,
    values_from = value,
    values_fill = list(value = 0)
  ) %>%
  arrange(Item, desc(Customer)) %>%
  mutate(`Item Total` = ItemA + ItemB + ItemC) %>%
  select(Customer, Org, Item, `Item Total`, Credit, Debit)

all.equal(input2, test)
# [1] TRUE
