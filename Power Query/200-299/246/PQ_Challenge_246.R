library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_246.xlsx"
input = read_excel(path, range = "A1:D14")
test  = read_excel(path, range = "F1:I5")

result = input %>%
  filter(Date == max(Date), .by = `Deal ID`) %>%
  select(-Date) %>%
  pivot_wider(names_from = Designation, values_from = Name, values_fn =  ~ str_c(.x, collapse = ", ")) %>%
  select(`Deal ID`, Mgr, GM, VP)

all.equal(result, test)
#> [1] TRUE