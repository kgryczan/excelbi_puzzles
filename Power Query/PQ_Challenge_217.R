library(tidyverse)
library(readxl)
library(janitor)

path = "Power Query/PQ_Challenge_217.xlsx"
input = read_excel(path, range = "A1:H5")
test  = read_excel(path, range = "J1:O8")

result = input %>%
  mutate(across(3:8, ~ . * Amt)) %>%
  select(-Amt) %>% 
  t() %>%
  as.data.frame() %>%
  row_to_names(1) %>%
  rownames_to_column(var = "Month")  %>%
  mutate(across(-Month, ~ as.numeric(.))) %>%
  adorn_totals(c("row", "col")) 

all.equal(result, test, check.attributes = FALSE)
# [1] TRUE