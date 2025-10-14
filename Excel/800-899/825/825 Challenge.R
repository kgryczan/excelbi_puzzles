library(tidyverse)
library(readxl)

path = "Excel/800-899/825/825 Unpivot.xlsx"
input = read_excel(path, range = "A2:D5")
test  = read_excel(path, range = "F2:H15")

result = input %>%
  pivot_longer(-ID, names_to = "Type", values_to = "Entity") %>%
  separate_longer_delim(Entity, delim = ", ") %>%
  arrange(ID, Type, Entity) %>%
  na.omit() %>%
  mutate(Type = paste0(Type,"-", row_number()), .by = Type) %>%
  select(ID, Entity, Type) %>%
  ungroup()

all.equal(result, test, check.attributes = FALSE)
# [1] TRUE