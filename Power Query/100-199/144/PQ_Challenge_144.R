library(tidyverse)
library(readxl)

input = read_excel("Power Query/PQ_Challenge_144.xlsx", range = "A1:B16")
test  = read_excel("Power Query/PQ_Challenge_144.xlsx", range = "E1:G16")

result = input %>%
  group_by(Group) %>%
  mutate(Half = ifelse(row_number() <= ceiling(n()/2), "First", "Second")) %>%
  ungroup() %>%
  group_by(Group, Half) %>%
  mutate(`Running Total` = cumsum(Value)) %>%
  ungroup() %>%
  select(-Half)

identical(result, test)
#> [1] TRUE

