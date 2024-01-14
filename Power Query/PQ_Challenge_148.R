library(tidyverse)
library(readxl)

input = read_excel("Power Query/PQ_Challenge_148.xlsx", range = "A1:A12")
test  = read_excel("Power Query/PQ_Challenge_148.xlsx", range = "C1:N12") 

result = input %>%
  separate_rows(Fruits, sep = ", ") %>%
  mutate(Fruits = str_remove_all(Fruits, " ")) %>%
  group_by(Fruits) %>%
  summarise(Count = n()) %>%
  ungroup() %>%
  mutate(Fruits2 = Fruits) %>%
  pivot_wider(names_from = Fruits2, values_from = Count) 

all.equal(result, test)
#> [1] TRUE
