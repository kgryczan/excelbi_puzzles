library(tidyverse)
library(readxl)

path = "Excel/200-299/257/257 Repeats.xlsx"
input = read_excel(path, range = "A1:C12")
test  = read_excel(path, range = "E1:G4") %>% replace(is.na(.), "")

result = input %>%
  pivot_longer(everything()) %>%
  mutate(rn = row_number(), .by = c("name", "value")) %>%
  filter(rn == 2) %>%
  mutate(rn = row_number(), .by = "name") %>%
  pivot_wider(names_from = name, values_from = value) %>%
  select(Greeks, Birds, Planets) %>%
  replace(is.na(.), "") 

all.equal(result, test, check.attributes = FALSE)
# > [1] TRUE