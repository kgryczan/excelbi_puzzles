library(tidyverse)
library(readxl)

path = "Excel/700-799/785/785 Pivot.xlsx"
input = read_excel(path, range = "A2:A6")
test  = read_excel(path, range = "C2:F6")

result = input %>%
  separate_longer_delim(Data, ", ") %>%
  separate_wider_delim(Data, ":", names = c("Variable", "Value")) %>%
  mutate(Value = trimws(Value), 
         group = cumsum(Variable == "Org")) %>%
  pivot_wider(names_from = Variable, values_from = Value) %>%
  mutate(across(-c(group, Org), as.numeric)) %>%
  mutate(
    Revenue = coalesce(Revenue, Cost + Profit),
    Cost    = coalesce(Cost, Revenue - Profit),
    Profit  = coalesce(Profit, Revenue - Cost)
  ) %>%
  select(-group)

all.equal(result, test, check.attributes = FALSE)
# > [1] TRUE