library(tidyverse)
library(readxl)

path = "Excel/700-799/750/750 Data Alignment.xlsx"
input = read_excel(path, range = "A1:A21")
test  = read_excel(path, range = "C2:E6")

result = input %>%
  mutate(group = cumsum(str_detect(Data, "Emp ID"))) %>% 
  mutate(cn = ifelse(row_number() > n() / 2, "values", "labels"), .by = group) %>%
  pivot_wider(names_from = cn, values_from = Data) %>%
  unnest() %>%
  pivot_wider(names_from = labels, values_from = values) %>%
  select(-group) %>% 
  mutate(across(c("Age", "Emp ID"), as.numeric)) 

all.equal(result, test)
# > [1] TRUE