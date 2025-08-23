library(tidyverse)
library(readxl)

path = "Power Query/300-399/315/PQ_Challenge_315.xlsx"
input = read_excel(path, range = "A1:D11")
test  = read_excel(path, range = "F1:J12")

result = input %>% 
  pivot_longer(cols = everything(), names_to = "Attribute", values_to = "Value" ) %>%
  arrange(Attribute) %>%
  mutate(r = (row_number() + 1) %% 2,
         nr = (row_number() + 1) %/% 2) %>%
  pivot_wider(id_cols = c(Attribute, nr), names_from = r, values_from = Value) %>%
  select(-nr) %>%
  pivot_wider(names_from  = `0`, values_from = `1`) %>%
  separate_longer_delim(cols = `Sold Items`, delim = " | ") %>%
  mutate(across(c(Turnover, `Sold Items`, Age), as.numeric)) %>%
  mutate(Turnover = Turnover / n(), .by = Attribute) %>%
  select(-Attribute) 

all.equal(result, test)
# > [1] TRUE