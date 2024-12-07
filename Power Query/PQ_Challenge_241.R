library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_241.xlsx"
input = read_excel(path, range = "A1:F5")
test  = read_excel(path, range = "A9:F20")

result = input %>%
  pivot_longer(-Group, names_to = "Name", values_to = "Value") %>%
  separate_rows(Value, sep = ", ") %>%
  mutate(rn = row_number(), .by = c(Group, Name)) %>%
  pivot_wider(names_from = Name, values_from = Value) %>%
  select(-rn)

all.equal(result, test, check.attributes = FALSE)
# [1] TRUE