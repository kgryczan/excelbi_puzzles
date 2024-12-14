library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_243.xlsx"
input = read_excel(path, range = "A1:B10")
test  = read_excel(path, range = "D1:G12")

result = input %>%
  mutate(Group_2 = paste0("Group", row_number()), .by = `Emp ID`) %>%
  arrange(`Emp ID`) %>%
  separate_rows(Group, sep = ", ") %>%
  mutate(x = row_number(), .by = c(`Emp ID`, Group_2)) %>%
  pivot_wider(names_from = Group_2, values_from = Group) %>%
  select(-x)

all.equal(result, test)
#> [1] TRUE