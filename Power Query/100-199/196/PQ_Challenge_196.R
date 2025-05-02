library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_196.xlsx"
input = read_xlsx(path, range = "A1:C11")
test  = read_xlsx(path, range = "F1:O5")

result = input %>%
  mutate(class1 = Class) %>%
  pivot_wider(names_from = Subject, values_from = c(class1, Marks), names_sep = "-") %>%
  select(-Class) %>%
  rename_with(~str_remove(., "class1-"), starts_with("class1-")) %>%
  select(sort(names(.), decreasing = FALSE)) %>%
  select(1:3,9:10, everything()) 

identical(result, test)
#> [1] TRUE