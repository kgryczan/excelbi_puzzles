library(tidyverse)
library(readxl)

path = "Excel/800-899/820/820 Stack Text and Numbers.xlsx"
input = read_excel(path, range = "A2:A11")
test  = read_excel(path, range = "B2:C24")

result = input %>%
  mutate(tok = str_extract_all(Data, "[A-Za-z]+|\\d+")) %>%
  unnest_longer(tok) %>%
  mutate(typ = if_else(str_detect(tok, "^\\d+$"), "Numbers", "Text"), .by = Data) %>%
  mutate(start = row_number() == 1 | !(typ == "Numbers" & lag(typ) == "Text"), .by = Data) %>%
  mutate(grp = cumsum(start), .by = Data) %>%
  select(-start) %>%
  pivot_wider(names_from = typ, values_from = tok) %>%
  mutate(Numbers = as.integer(Numbers)) %>%
  select(-c(grp, Data)) 

all.equal(result, test)
# [1] TRUE