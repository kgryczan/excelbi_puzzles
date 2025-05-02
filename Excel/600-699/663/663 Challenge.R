library(tidyverse)
library(readxl)

path = "Excel/663 Pivot for levels.xlsx"
input = read_excel(path, range = "A1:B10")
test  = read_excel(path, range = "D2:I5") %>%
  mutate(across(everything(), as.numeric)

result = input %>% 
  mutate(Level = as.character(as.numeric(Level))) %>%
  separate(Level, into = c("Level", "Sublevel"), sep = "\\.") %>%
  replace_na(list(Sublevel = "0")) %>%
  pivot_wider(names_from = Sublevel, values_from = Value) %>%
  mutate(across(everything(), as.numeric))

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE