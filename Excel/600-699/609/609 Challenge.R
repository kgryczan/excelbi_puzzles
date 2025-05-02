library(tidyverse)
library(readxl)

path = "Excel/609 Missing Terms in AP_3.xlsx"
input = read_excel(path, range = "A1:J10", col_types = "numeric")
test  = read_excel(path, range = "A13:J22")

result = input %>%
  rowwise() %>%
  mutate(last_col = max(which(!is.na(c_across(everything())))), 
         last_val = c_across(everything())[last_col],
         first_val = c_across(everything())[1]) %>%
  mutate(seq = list(seq(first_val, last_val, by = (last_val - first_val) / (last_col - 1)))) %>%
  unnest_wider(seq, names_sep = "_u") %>%
  select(starts_with("seq")) %>%
  set_names(names(input)) 
  
all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE
