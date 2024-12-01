library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_240.xlsx"
input = read_excel(path, range = "A1:C8")
test  = read_excel(path, range = "E1:J8")

result = input %>%
  separate_rows(Items, sep = ", ") %>%
  separate(Items, into = c("Item", "Quantity"), sep = ": ") %>%
  mutate(Quantity = as.numeric(Quantity)) %>%
  pivot_wider(names_from = Item, values_from = Quantity) %>%
  select(Supplier, Date, Bread, Coke, Milk, Rice) %>%
  arrange(Supplier, desc(Date))

all.equal(result, test, check.attributes = FALSE)
