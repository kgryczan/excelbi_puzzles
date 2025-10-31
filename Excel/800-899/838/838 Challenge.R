library(tidyverse)
library(readxl)

path = "Excel/800-899/838/838 Stack.xlsx"
input = read_excel(path, range = "A2:B10")
test  = read_excel(path, range = "C2:E6")

result = input %>%
  separate_rows(Item, sep = "/") %>%
  distinct() %>%
  arrange(Store, Item) %>%
  mutate(nr = row_number(), .by = Store) %>%
  pivot_wider(names_from = Store, values_from = Item) %>%
  select(-nr)

# Cannot validate, Unexpected C in output 