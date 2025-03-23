library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_272.xlsx"
input = read_excel(path, range = "A1:F5")
test  = read_excel(path, range = "H1:N8")

result = input %>%
  pivot_longer(-Date, names_to = "IDS", values_to = "Value") %>%
  separate_rows(Value, sep = ",") %>%
  na.omit() %>%
  mutate(Value = trimws(Value), rn = row_number(), .by = c(Date, IDS)) %>%
  pivot_wider(names_from = IDS, values_from = Value) %>%
  arrange(rn, Date) %>%
  select(-rn) %>%
  mutate(Seq = row_number(), .before = everything())

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE