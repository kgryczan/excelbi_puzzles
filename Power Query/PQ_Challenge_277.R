library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_277.xlsx"
input = read_excel(path, range = "A1:B10")
test  = read_excel(path, range = "D1:H4")

result = input %>%
  mutate(country = ifelse(is.na(Data2), Data1, NA)) %>%
  fill(country) %>% 
  na.omit() %>%
  separate_rows(c(Data1, Data2)) %>%
  mutate(Data2 = as.numeric(Data2)) %>%
  pivot_wider(names_from = Data1, values_from = Data2) 

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE