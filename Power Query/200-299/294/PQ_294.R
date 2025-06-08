library(tidyverse)
library(readxl)

path = "Power Query/200-299/294/PQ_Challenge_294.xlsx"
input = read_excel(path, range = "A1:A12")
test = read_excel(path, range = "C1:F4")

result = input %>%
  filter(str_detect(Data, "Group")) %>%
  separate_wider_delim(Data, " - ", names = c("Group", "Item", "Value")) %>%
  type_convert() %>%
  mutate(Group = str_remove(Group, "Group ")) %>%
  pivot_wider(names_from = Item, values_from = Value, values_fn = sum) %>%
  select(Group, sort(names(.))) %>%
  arrange(Group)

all.equal(result, test, check.attributes = FALSE)
# wrong expected result.
