library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_216.xlsx"
input = read_excel(path, range = "A1:E6")
test  = read_excel(path, range = "A11:E16")

result = input %>%
  pivot_longer(everything(), names_to = "Column", values_to = "Item") %>%
  mutate(Column = str_remove(Column, "Column"), 
         item_n = str_remove(Item, "Item") %>% as.numeric()) %>%
  arrange(Column) %>%
  mutate(rn = row_number(), .by = Column) %>%
  mutate(Column_label = paste0("Items ", min(item_n, na.rm = TRUE), " - ", max(item_n, na.rm = TRUE)), .by = rn) %>%
  select(Column_label, Item, Column) %>%
  pivot_wider(names_from = Column_label, values_from = Item) %>%
  select(-Column)

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE