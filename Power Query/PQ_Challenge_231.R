library(tidyverse)
library(readxl)
library(janitor)

path = "Power Query/PQ_Challenge_231.xlsx"
input1 = read_excel(path, range = "A2:C5")
input2 = read_excel(path, range = "A8:B15")
test  = read_excel(path, range = "E2:J6")

input = input1 %>%
  separate_rows(c(Items, Quantity), sep = ", ") %>%
  left_join(input2, by = "Items") %>%
  mutate(Amount = as.numeric(Quantity) * Price) %>%
  select(-c(Price, Quantity)) %>%
  pivot_wider(names_from = "Items", values_from = "Amount", values_fn = list(Amount = sum), values_fill = 0) %>%
  select(Name = Person,u, x, y, z) %>%
  arrange(Name) %>%
  adorn_totals(c("row", "col")) 

all.equal(input, test, check.attributes = FALSE)
#> [1] TRUE